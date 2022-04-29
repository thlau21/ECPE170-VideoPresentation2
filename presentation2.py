import socket
import struct
import sys



def main():
    server_ip = "54.148.163.48"
    port = 3456
    server_address = (server_ip, port)

    try:
        udp = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    except:
        print("Error, couldn't make UDP socket")
        sys.exit()

    #create request
    ProtocolNum = 1
    A = 30
    B = 70
    myName = 'Thomas Lau'

    #pack big endian then the char stands for how many bytes each items are then add n bytes based on my name
    request = struct.pack(">biii", ProtocolNum, A, B, len(myName)) + bytes(myName, 'ascii')

    #send request
    udp.sendto(request, server_address)

    #receive respose
    raw_bytes, rec_addy = udp.recvfrom(4096)
    
    #close socket
    udp.close()

    #decode response
    rec_protocolNum, stat_code, total_sum = struct.unpack("!BHI", raw_bytes)
    if stat_code != 1:
        print("Fail\n")
    else:
        print("Success\n")
        print(f"{A}+{B}={total_sum}\n")

if __name__ == "__main__":
    sys.exit(main())