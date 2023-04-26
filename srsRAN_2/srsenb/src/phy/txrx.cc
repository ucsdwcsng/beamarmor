/**
 * Copyright 2013-2022 Software Radio Systems Limited
 *
 * This file is part of srsRAN.
 *
 * srsRAN is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of
 * the License, or (at your option) any later version.
 *
 * srsRAN is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * A copy of the GNU Affero General Public License can be found in
 * the LICENSE file in the top-level directory of this distribution
 * and at http://www.gnu.org/licenses/.
 *
 */

#include <unistd.h>

#include <fstream>
#include <string>
#include <zmq.hpp>
#include <msgpack.hpp>
#include <chrono>

#include "srsenb/hdr/phy/txrx.h"
#include "srsran/common/band_helper.h"
#include "srsran/common/threads.h"
#include "srsran/srsran.h"

#define Error(fmt, ...)                                                                                                \
  if (SRSRAN_DEBUG_ENABLED)                                                                                            \
  logger.error(fmt, ##__VA_ARGS__)
#define Warning(fmt, ...)                                                                                              \
  if (SRSRAN_DEBUG_ENABLED)                                                                                            \
  logger.warning(fmt, ##__VA_ARGS__)
#define Info(fmt, ...)                                                                                                 \
  if (SRSRAN_DEBUG_ENABLED)                                                                                            \
  logger.info(fmt, ##__VA_ARGS__)
#define Debug(fmt, ...)                                                                                                \
  if (SRSRAN_DEBUG_ENABLED)                                                                                            \
  logger.debug(fmt, ##__VA_ARGS__)

using namespace std;

namespace srsenb {

txrx::txrx(srslog::basic_logger& logger) : thread("TXRX"), logger(logger), running(false)
{
  /* Do nothing */
}

bool txrx::init(enb_time_interface*          enb_,
                srsran::radio_interface_phy* radio_h_,
                lte::worker_pool*            lte_workers_,
                phy_common*                  worker_com_,
                prach_worker_pool*           prach_,
                uint32_t                     prio_)
{
  enb         = enb_;
  radio_h     = radio_h_;
  lte_workers = lte_workers_;
  worker_com  = worker_com_;
  prach       = prach_;
  running     = true;

  // Instantiate UL channel emulator
  if (worker_com->params.ul_channel_args.enable) {
    ul_channel = srsran::channel_ptr(
        new srsran::channel(worker_com->params.ul_channel_args, worker_com->get_nof_rf_channels(), logger));
  }

  start(prio_);
  return true;
}

bool txrx::set_nr_workers(nr::worker_pool* nr_workers_)
{
  nr_workers = nr_workers_;
  return true;
}

void txrx::stop()
{
  if (running) {
    running = false;
    wait_thread_finish();
  }
}

std::complex<double> get_alpha(cf_t* y1, cf_t* y2, uint32_t tti, uint32_t sf_len, zmq::socket_t& socket)
{
  // std::cout << "get alpha called" << '\n';
  
  // Send y1 and y2 via ZMQ:
  int size = 4 * sf_len;
  // Serialize the samples data using MessagePack
  msgpack::sbuffer buffer;
  msgpack::packer<msgpack::sbuffer> packer(&buffer);
  // Pack the size of the sent samples first
  packer.pack_array(size);

  // Pack each sample's real and imaginary part
  for (int i = 0; i < (int)sf_len; i++) {
    std::complex<double> y1_sample = (std::complex<double>)y1[i];
    std::complex<double> y2_sample = (std::complex<double>)y2[i];
    packer.pack_double(std::floor(y1_sample.real() * 10e5) / 10e5);
    packer.pack_double(std::floor(y1_sample.imag() * 10e5) / 10e5);
    packer.pack_double(std::floor(y2_sample.real() * 10e5) / 10e5);
    packer.pack_double(std::floor(y2_sample.imag() * 10e5) / 10e5);
  }

  // std::cout << "Set ZMQ message" << "; TTI: " << tti << '\n';
  zmq::message_t y_msg(buffer.data(), buffer.size(), nullptr);
  // std::cout << "Send from socket" << '\n';
  socket.send(y_msg, zmq::send_flags::none);
  
  zmq::message_t reply;
  socket.recv(reply, zmq::recv_flags::none);
  // std::cout << "Received reply" << '\n';
  
  // De-serialize reply
  msgpack::object_handle oh = msgpack::unpack(static_cast<char*>(reply.data()), reply.size());
  msgpack::object obj = oh.get();

  std::vector<double> alpha_parts = obj.as<std::vector<double>>();
  std::complex<double> alpha{alpha_parts[0], alpha_parts[1]};
  // std::cout << "Alpha: " << alpha << '\n';

  return alpha;
}

void txrx::run_thread()
{
  srsran::rf_buffer_t    buffer    = {};
  srsran::rf_timestamp_t timestamp = {};
  uint32_t               sf_len    = SRSRAN_SF_LEN_PRB(worker_com->get_nof_prb(0));
  // Needed when y1 and y2 are written to file for 100 consecutive TTIs:
  // string tti_mod100 = "";
  // ofstream y1_file, y2_file;
  // std::ofstream get_alpha_rrt("../../get_alpha_rtt.txt", std::ios::app);
  // NullSteer
  std::complex<double> alpha(0,0);
  std::complex<double> dummy_alpha(0,0);
  int alpha_compute_counter = 66;

  // Init ZMQ: It is used to communicate y1 and y2 to an external program
  // which calcualates alpha* and returns that value
  zmq::context_t context(1);
  zmq::socket_t socket(context, ZMQ_REQ);
  socket.connect("tcp://localhost:5555");

  float samp_rate = srsran_sampling_freq_hz(worker_com->get_nof_prb(0));

  srsran::srsran_band_helper band_helper;

  // Configure radio
  radio_h->set_rx_srate(samp_rate);
  radio_h->set_tx_srate(samp_rate);

  // Set Tx/Rx frequencies
  for (uint32_t cc_idx = 0; cc_idx < worker_com->get_nof_carriers(); cc_idx++) {
    double   tx_freq_hz = worker_com->get_dl_freq_hz(cc_idx);
    double   rx_freq_hz = worker_com->get_ul_freq_hz(cc_idx);
    uint32_t rf_port    = worker_com->get_rf_port(cc_idx);
    if (cc_idx < worker_com->get_nof_carriers_lte()) {
      srsran::console("Setting frequency: DL=%.1f Mhz, UL=%.1f MHz for cc_idx=%d nof_prb=%d\n",
                      tx_freq_hz / 1e6f,
                      rx_freq_hz / 1e6f,
                      cc_idx,
                      worker_com->get_nof_prb(cc_idx));
    } else {
      srsran::console(
          "Setting frequency: DL=%.1f Mhz, DL_SSB=%.2f Mhz (SSB-ARFCN=%d), UL=%.1f MHz for cc_idx=%d nof_prb=%d\n",
          tx_freq_hz / 1e6f,
          worker_com->get_ssb_freq_hz(cc_idx) / 1e6f,
          band_helper.freq_to_nr_arfcn(worker_com->get_ssb_freq_hz(cc_idx)),
          rx_freq_hz / 1e6f,
          cc_idx,
          worker_com->get_nof_prb(cc_idx));
    }

    radio_h->set_tx_freq(rf_port, tx_freq_hz);
    radio_h->set_rx_freq(rf_port, rx_freq_hz);
  }

  // Set channel emulator sampling rate
  if (ul_channel) {
    ul_channel->set_srate(static_cast<uint32_t>(samp_rate));
  }

  logger.info("Starting RX/TX thread nof_prb=%d, sf_len=%d", worker_com->get_nof_prb(0), sf_len);

  // Set TTI so that first TX is at tti=0
  tti = TTI_SUB(0, FDD_HARQ_DELAY_UL_MS + 1);

  // Main loop
  while (running) {
    tti = TTI_ADD(tti, 1);
    logger.set_context(tti);

    lte::sf_worker* lte_worker = nullptr;
    if (worker_com->get_nof_carriers_lte() > 0) {
      lte_worker = lte_workers->wait_worker(tti);
      if (lte_worker == nullptr) {
        // wait_worker() only returns NULL if it's being closed. Quit now to avoid unnecessary loops here
        running = false;
        continue;
      }
    }

    nr::slot_worker* nr_worker = nullptr;
    if (nr_workers != nullptr and worker_com->get_nof_carriers_nr() > 0) {
      nr_worker = nr_workers->wait_worker(tti);
      if (nr_worker == nullptr) {
        running = false;
        continue;
      }
    }

    // Multiple cell buffer mapping
    {
      uint32_t cc = 0;
      for (uint32_t cc_lte = 0; cc_lte < worker_com->get_nof_carriers_lte(); cc_lte++, cc++) {
        uint32_t rf_port = worker_com->get_rf_port(cc);

        for (uint32_t p = 0; p < worker_com->get_nof_ports(cc); p++) {
          // WARNING: The number of ports for all cells must be the same
          buffer.set(rf_port, p, worker_com->get_nof_ports(0), lte_worker->get_buffer_rx(cc_lte, p));
        }
      }
      for (uint32_t cc_nr = 0; cc_nr < worker_com->get_nof_carriers_nr(); cc_nr++, cc++) {
        uint32_t rf_port = worker_com->get_rf_port(cc);

        for (uint32_t p = 0; p < worker_com->get_nof_ports(cc); p++) {
          // WARNING:
          // - The number of ports for all cells must be the same
          // - Only one NR cell is currently supported
          if (nr_worker != nullptr) {
            buffer.set(rf_port, p, worker_com->get_nof_ports(0), nr_worker->get_buffer_rx(p));
          }
        }
      }
    }

    buffer.set_nof_samples(sf_len);
    radio_h->rx_now(buffer, timestamp);

    // NullSteer:
    // Get raw y1 and y2
    // std::cout << "Get raw y1 and y2" << '\n';
    cf_t* y1 = buffer.get(0);
    cf_t* y2 = buffer.get(1);

    // Get alpha from external program every 100 TTI
    if (tti % 1000 == 0 && alpha_compute_counter != 99)
    {
      if (alpha_compute_counter < 5)
      {
        std::cout << 65-alpha_compute_counter << " seconds remaining" << '\n';
        std::cout << "Using alpha: " << dummy_alpha << '\n';
        alpha = get_alpha(y1, y2, tti, sf_len, socket);
        alpha_compute_counter++;
      }
      else if(alpha_compute_counter == 5) {
        std::cout << "Alpha compute stopped." << '\n';
        std::cout << 65-alpha_compute_counter << " seconds remaining" << '\n';
        std::cout << "Using alpha: " << dummy_alpha << '\n';
        alpha_compute_counter++;
      }
      else if (alpha_compute_counter == 66)
      {
        // std::chrono::steady_clock::time_point start = std::chrono::steady_clock::now();
        // alpha = get_alpha(y1, y2, tti, sf_len, socket);
        // std::chrono::steady_clock::time_point end = std::chrono::steady_clock::now();
        // std::chrono::duration<double> elapsed_seconds = end - start;
        // if (get_alpha_rrt.is_open()) {
        //   get_alpha_rrt << elapsed_seconds.count() << ",";
        // }
        std::cout << "Using alpha: " << dummy_alpha << '\n';
        alpha_compute_counter = 99;
      } else {        
        std::cout << 65-alpha_compute_counter << " seconds remaining" << '\n';
        std::cout << "Using alpha: " << dummy_alpha << '\n';
        alpha_compute_counter++;
      }
    }

    // Apply alpha to UL sample buffer
    if (alpha_compute_counter == 99) {
      buffer.apply_alpha(alpha, sf_len);
    } else {
      buffer.apply_alpha(dummy_alpha, sf_len);
    }

    // cf_t* tmp = lte_worker->get_buffer_rx(0, 0);
    // printf("signal_buffer_rx[0][0]: %f+%fi\n", __real__ tmp[0], __imag__ tmp[0]);
    // std::cout << "signal_buffer_rx[0] addr: " << tmp << '\n';
    // std::cout << "-----------------------" << '\n';

    // Write y1 and y2 to file
    // tti_mod100 = std::to_string(tti % 100);
    // y1_file.open("../../y1y2_for_100TTIs/y1_"+tti_mod100+".txt");
    // y2_file.open("../../y1y2_for_100TTIs/y2_"+tti_mod100+".txt");
    // if ((tti+500) % 1000 == 0) {
    //   y1_file.open("../../y1_.txt");
    //   y2_file.open("../../y2_.txt");
    //   for (uint32_t i = 0; i < sf_len; i++) {
    //     y1_file << (std::complex<double>)y1[i] << '\n';
    //     y2_file << (std::complex<double>)y2[i] << '\n';
    //   }
    //   y1_file.close();
    //   y2_file.close();
    // }

    if (ul_channel) {
      ul_channel->run(buffer.to_cf_t(), buffer.to_cf_t(), sf_len, timestamp.get(0));
    }

    // Compute TX time: Any transmission happens in TTI+4 thus advance 4 ms the reception time
    timestamp.add(FDD_HARQ_DELAY_UL_MS * 1e-3);

    Debug("Setting TTI=%d, tx_time=%ld:%f to worker %d",
          tti,
          timestamp.get(0).full_secs,
          timestamp.get(0).frac_secs,
          lte_worker ? lte_worker->get_id() : 0);

    // Trigger prach worker execution
    for (uint32_t cc = 0; cc < worker_com->get_nof_carriers_lte(); cc++) {
      prach->new_tti(cc, tti, buffer.get(worker_com->get_rf_port(cc), 0, worker_com->get_nof_ports(0)));
    }

    // Set NR worker context and start
    if (nr_worker != nullptr) {
      srsran::phy_common_interface::worker_context_t context;
      context.sf_idx     = tti;
      context.worker_ptr = nr_worker;
      context.last       = (lte_worker == nullptr); // Set last if standalone
      context.tx_time.copy(timestamp);

      nr_worker->set_context(context);

      // Start NR worker processing
      worker_com->semaphore.push(nr_worker);
      nr_workers->start_worker(nr_worker);
    }

    // Set LTE worker context and start
    if (lte_worker != nullptr) {
      srsran::phy_common_interface::worker_context_t context;
      context.sf_idx     = tti;
      context.worker_ptr = lte_worker;
      context.last       = true;
      context.tx_time.copy(timestamp);

      lte_worker->set_context(context);

      // Start LTE worker processing
      worker_com->semaphore.push(lte_worker);
      lte_workers->start_worker(lte_worker);
    }

    // Advance in time
    enb->tti_clock();
  }
}

} // namespace srsenb
