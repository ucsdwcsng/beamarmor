from time import sleep
import time
import zmq
import numpy as np
import msgpack

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

if __name__ == "__main__":

    context = zmq.Context()
    subscriber_socket = context.socket(zmq.SUB)
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
            
            # Compute alpha for BeamArmor's anti-jamming
            # alpha = compute_alpha(data)
            
            # Saving 100 pairs of y1 and y2 to file
            # if i < 100:
            #     save_y1y2_file(data,i)
            #     i = i+1
            # else:
            #     exit()

            # Sending dummy alpha immediatley
            alpha = 0

            # Return alpha to srseNB
            alpha_msg = msgpack.packb([alpha.real, alpha.imag])
            publisher_socket.send(alpha_msg)