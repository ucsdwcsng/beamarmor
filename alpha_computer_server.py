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

    # Save y1 and y2 to file
    # np.savetxt('y1.txt', y1, delimiter=',')
    # np.savetxt('y2.txt', y1, delimiter=',')

    # Compute alpha
    alpha = (-1) * np.dot(np.transpose(y2.conj()), y1) / np.dot(np.transpose(y2.conj()), y2)
    print("Alpha: ", alpha)

    # Return alpha
    return alpha

def save_y1y2_to_file(y1y2, suffix):
    y1 = np.array(y1y2[::4], dtype=complex) + 1j*np.array(y1y2[1::4], dtype=complex)
    y2 = np.array(y1y2[2::4], dtype=complex) + 1j*np.array(y1y2[3::4], dtype=complex)

    # Save y1 and y2 to file
    np.savetxt('y1_'+str(suffix)+'.txt', y1, delimiter=',')
    np.savetxt('y2_'+str(suffix)+'.txt', y2, delimiter=',')


if __name__ == "__main__":

    context = zmq.Context()
    socket = context.socket(zmq.REP)

    socket.bind("tcp://*:5555")

    times_y1y2_saved = 0

    print("alpha-compute server started.")
    while True:
        reply = socket.recv()
        print("Received message.")
        reply_unpacked = msgpack.unpackb(reply)
        # Send back a dummy alpha = 0
        print("Sending immediate response!")
        immediate_msg = msgpack.packb([0, 0])
        socket.send(immediate_msg)

        # print("y1.1 real:", reply_unpacked[0])
        # print("y1.1 imag:", reply_unpacked[1])
        # print("y2.1 real:", reply_unpacked[2])
        # print("y2.1 imag:", reply_unpacked[3])

        # print("Compute alpha now...")
        # # print("Length of reply: ", len(reply_unpacked))
        # alpha = compute_alpha(reply_unpacked)

        # Return alpha to srseNB
        # alpha_msg = msgpack.packb([alpha.real, alpha.imag])
        # socket.send(alpha_msg)
        # socket.send_string("ACK")
        
        save_y1y2_to_file(reply_unpacked, times_y1y2_saved)
        print("y1y2 file saved!")
        times_y1y2_saved += 1