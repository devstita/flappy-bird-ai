from serial_connection import ConnectionManager

PORT = 9857

conn, addr = ConnectionManager.connect(PORT)

data = ConnectionManager.read(conn)
while not (data is "disc" or not data):
    inputs = data.split(',')
    # print(inputs)
    ConnectionManager.send(conn, 1)

    data = ConnectionManager.read(conn)
