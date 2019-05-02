import socket


# TODO: Develop Python - Java Connection
class ConnectionManager:
    def __init__(self, port=9999):
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.connect()

    def connect(self):
        self.sock.bind(("127.0.0.1", self.port))
        self.sock.listen(self.port)
        conn, addr = self.sock.accept()

        data = conn.recv(1024).decode(encoding="UTF-8")
        while not (data is "disc" or data is ''):
            inputs = data.split(',')
            print(inputs)

            data = conn.recv(1024).decode(encoding="UTF-8")

        print('Disconnected')
