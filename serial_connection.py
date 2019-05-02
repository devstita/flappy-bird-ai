import socket


class ConnectionManager:
    def __init__(self):
        pass

    @staticmethod
    def connect(port=9999):
        port = port
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

        sock.bind(("127.0.0.1", port))
        sock.listen(port)

        conn, addr = sock.accept()
        return conn, addr

    @staticmethod
    def read(conn):
        return conn.recv(1024).decode(encoding="UTF-8")

    @staticmethod
    def send(conn, value):
        data = bytes([value])
        # data = str(value).encode()
        print("Send:", data)
        conn.sendall(data)

    @staticmethod
    def is_disconnected(conn):
        return conn.fileno() == -1

