from time import sleep
import time
import zmq
import numpy as np
import msgpack

def compute_alpha(y1y2):
    # Transform y1y2 list of doubles holfing real and imag parts into np vectors
    # y_len = int(len(y1y2)/4)
    # y1 = np.empty((y_len,), dtype=complex)
    # y2 = np.empty((y_len,), dtype=complex)
    # for i in range(y_len):
    #     y1[i] = complex(y1y2[i*4], y1y2[i*4+1])
    #     y2[i] = complex(y1y2[i*4+2], y1y2[i*4+3])
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    # Compute alpha
    alpha = (-1) * np.dot(np.transpose(y2.conj()), y1) / np.dot(np.transpose(y2.conj()), y2)
    print("Alpha: ", alpha)

    # Return alpha
    return alpha

def save_y1y2_file(y1y2,i):
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    # Save y1 and y2 to file
    np.savetxt('y1y2_milcom/ueON_3and3dBTXandRXgain/jammer30dB/y1_'+str(i)+'.txt', y1, delimiter=',')
    np.savetxt('y1y2_milcom/ueON_3and3dBTXandRXgain/jammer30dB/y2_'+str(i)+'.txt', y2, delimiter=',')
    print("y1y2 file saved")

if __name__ == "__main__":

    context = zmq.Context()
    subscriber_socket = context.socket(zmq.SUB)
    # subscriber_socket.setsockopt(zmq.SUBSCRIBE, b"")
    subscriber_socket.setsockopt_string(zmq.SUBSCRIBE, "")
    subscriber_socket.connect("tcp://localhost:5555")
    
    publisher_socket = context.socket(zmq.PUB)
    publisher_socket.bind("tcp://*:5556")

    # Set up polling
    poller = zmq.Poller()
    poller.register(subscriber_socket, zmq.POLLIN)

    i = 0

    print("alpha-compute server started.")

    while True:
        # Poll for incoming messages
        events = dict(poller.poll(timeout=10))  # Adjust the timeout as needed
        
        # Check if there are messages to process
        if subscriber_socket in events and events[subscriber_socket] == zmq.POLLIN:
            # Receive the message
            message = subscriber_socket.recv()
            
            # Flush any remaining data at the subscriber socket
            while subscriber_socket.getsockopt(zmq.RCVMORE):
                subscriber_socket.recv()

            # Process the received message
            data = msgpack.unpackb(message)

            # alpha = compute_alpha(data)
            
            # Saving y1 and y2 to file
            save_y1y2_file(data,i)
            i = i+1

            # Sending dummy alpha immediatley
            alpha = 0

            # Return alpha to srseNB
            alpha_msg = msgpack.packb([alpha.real, alpha.imag])
            publisher_socket.send(alpha_msg)
            # print("Sleeping 2 sec")
            # sleep(2)
            # socket.send_string("ACK")