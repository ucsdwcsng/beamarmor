from time import sleep
import time
import zmq
import numpy as np
import msgpack
import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QWidget, QLabel, QPushButton, QVBoxLayout
import threading

apply_alpha_toggle = False

class MainWindow(QMainWindow):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)

        self.widget = QWidget()
        layout = QVBoxLayout()
        self.widget.setLayout(layout)
        self.btn_start = QPushButton('BeamArmor OFF', clicked = self.toggle)
        self.btn_start.setStyleSheet('background-color: red')
        self.setCentralWidget(self.btn_start)

        self.show()

    def toggle(self):
        global apply_alpha_toggle
        apply_alpha_toggle = not apply_alpha_toggle
        if apply_alpha_toggle:           
            # print("Sending alpha..")
            self.btn_start.setText('BeamArmor ON')
            self.btn_start.setStyleSheet('background-color: green')
        else:
            # print("Sending zeros...")
            self.btn_start.setText('BeamArmor OFF')
            self.btn_start.setStyleSheet('background-color: red')


# Computes alpha for BeamArmor's anti-jamming
def compute_alpha(y1y2):
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    # Compute alpha
    alpha = (-1) * np.dot(np.transpose(y2.conj()), y1) / np.dot(np.transpose(y2.conj()), y2)
    print("Alpha: ", alpha)

    # Return alpha
    return alpha

# Saves y1 and y2 received from the RAN/srsenb to a file
def save_y1y2_file(y1y2,i):
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    # Save y1 and y2 to file
    np.savetxt('y1_'+str(i)+'.txt', y1, delimiter=',')
    np.savetxt('y2_'+str(i)+'.txt', y2, delimiter=',')
    print("y1y2 file saved")

def print_y1y2(y1y2):
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    print("---------------------------")
    print("y1[0]: ", y1[0])
    print("y2[0]: ", y2[0])  

def beam_armour():
    context = zmq.Context()
    subscriber_socket = context.socket(zmq.SUB)
    subscriber_socket.setsockopt_string(zmq.SUBSCRIBE, "")
    subscriber_socket.connect("tcp://localhost:5555")
    
    publisher_socket = context.socket(zmq.PUB)
    publisher_socket.bind("tcp://*:5556")

    # Set up polling
    poller = zmq.Poller()
    poller.register(subscriber_socket, zmq.POLLIN)

    compute_started_flag = 1

    alpha_estimation_timer = int(sys.argv[1])
    alpha_estimated_flag = 0
    sum_alpha = 0
    num_alpha = 0

    print_zero_flag = 1
    print_alpha_flag = 1

    dummy_msg = msgpack.packb([0, 0])

    print("alpha-compute server started.")

    while True:
        
        # Poll for incoming messages
        events = dict(poller.poll(timeout=20))  # Adjust the timeout as needed
        
        # Check if there are messages to process
        if subscriber_socket in events and events[subscriber_socket] == zmq.POLLIN:
            # Receive the message
            if compute_started_flag:
                start_time = time.time()
                compute_started_flag = 0
                elapsed_time = time.time() - start_time

            message = subscriber_socket.recv()

            # Flush any remaining data at the subscriber socket
            while subscriber_socket.getsockopt(zmq.RCVMORE):
                subscriber_socket.recv()
            try:
            # Process the received message
                data = msgpack.unpackb(message)
            except msgpack.exceptions.UnpackValueError:
                pass
            
            if elapsed_time < alpha_estimation_timer:
            # Compute alpha for BeamArmor's anti-jamming
                alpha = compute_alpha(data)
                sum_alpha = sum_alpha + alpha
                num_alpha = num_alpha + 1
            elif not alpha_estimated_flag:
                print("**********************************************Estimated alpha...**********************************************")
                alpha_estimated_flag = 1
                final_alpha = sum_alpha / num_alpha
                print("Final alpha: ", final_alpha)

            # Return alpha to srseNB
            if not apply_alpha_toggle:
                if print_zero_flag:
                    print("Sending zeros...")
                    print_zero_flag = 0
                print_alpha_flag = 1
                publisher_socket.send(dummy_msg)
            else:
                if print_alpha_flag:
                    print("Sending alphas...")
                    print_alpha_flag = 0
                print_zero_flag = 1
                alpha_msg = msgpack.packb([final_alpha.real, final_alpha.imag])
                publisher_socket.send(alpha_msg)

            elapsed_time = time.time() - start_time

if __name__ == "__main__":
    t = threading.Thread(target=beam_armour)
    t.daemon = True
    t.start()

    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec())
