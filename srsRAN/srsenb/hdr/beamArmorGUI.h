#include <FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Chart.H>
// #include <matplot/matplot.h>
#include <gnuplot-iostream.h>
#include <iostream>
#include <thread>
#include <atomic>
#include <chrono>

extern double bler;
extern double sinr;
extern double throughput;
// double a = 0; 

std::vector<double> bler_vector;
std::vector<double> sinr_vector;
std::vector<double> tput_vector;
Gnuplot gp;
Gnuplot bler_plot;
Gnuplot sinr_plot;
Gnuplot tput_plot;

void updatePlot(){
        // Draw plots and configure the plot parameters
        bler_plot << "set terminal wxt size 600,500 position 10,0\n";
        bler_plot << "set title 'BLER' font 'sans,38'\n";
        bler_plot << "set grid\n";
        bler_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        bler_plot << "set ylabel 'BLER (%)' font 'sans,25'\n";
        bler_plot << "set xrange [0:200]\nset yrange [0:100]\n";
        bler_plot << "set xtics 20\n";

        sinr_plot << "set terminal wxt size 600,500 position 685,0\n";
        sinr_plot << "set title 'SINR' font 'sans,38'\n";
        sinr_plot << "set grid\n";
        sinr_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        sinr_plot << "set ylabel 'SINR (dB)' font 'sans,25'\n";
        sinr_plot << "set xrange [0:200]\nset yrange [0:50]\n";
        sinr_plot << "set xtics 20\n";

        tput_plot << "set terminal wxt size 600,500 position 1300,0\n";
        tput_plot << "set title 'Throughput' font 'sans,38'\n";
        tput_plot << "set grid\n";
        tput_plot << "set xlabel 'Time (s)' font 'sans,25'\n";
        tput_plot << "set ylabel 'Throughput (Mbps)' font 'sans,25'\n";
        tput_plot << "set xrange [0:200]\nset yrange [0:25]\n";
        tput_plot << "set xtics 20\n";

    while (true){

        // Reset plot when the vector size exceeds the x-axis of the plots
        if (tput_vector.size() == 200){
            tput_vector.erase(tput_vector.begin(), tput_vector.begin() + 200);
            sinr_vector.erase(sinr_vector.begin(), sinr_vector.begin() + 200);
            bler_vector.erase(bler_vector.begin(), bler_vector.begin() + 200);
        }
        bler_vector.push_back(bler);
        sinr_vector.push_back(sinr);
        tput_vector.push_back(throughput/1000000);

        tput_plot << "plot '-' with lines lw 5 lc 'blue' title 'Throughput'\n";
        tput_plot.send1d(tput_vector); 

        sinr_plot << "plot '-' with lines lw 5 lc 'green' title 'SINR'\n";
        sinr_plot.send1d(sinr_vector);

        bler_plot << "plot '-' with lines lw 5 lc 'red' title 'BLER'\n";
        bler_plot.send1d(bler_vector);

        std::this_thread::sleep_for(std::chrono::milliseconds(1000)); // Refresh rate of values
    }
}

void start_beamArmorGUI() {

#ifdef _WIN32
  // For Windows, prompt for a keystroke before the Gnuplot object goes out of scope so that
  // the gnuplot window doesn't get closed.
  std::cout << "Press enter to exit." << std::endl;
  std::cin.get();
#endif
std::thread displayThread(updatePlot);

    displayThread.join();
}