import processing.net.*;

// TODO: Develop Serial Connection with Python ML Agent
class SerialConnection {
    String server;
    int port;

    Client client;
    
    public SerialConnection(String server, int port) {
        this.server = server;
        this.port = port;
        connect();
    }

    private void connect() {
        this.client = new Client(Engine.this, server, port);
    }

    public void sendData(FloatList list) {
        String msg = "";

        if (list.size() > 0) {
            for (int i = 0; i < list.size() - 1; i++) msg += (str(list.get(i)) + ",");
            msg += list.get(list.size() - 1);
        } else {
            error("ML Data is Empty");
        }

        send(msg);
    }

    public void send(String msg) {
        if (!client.active()) error("Socket is disactivated");
        else {
            client.write(msg);
        }
    }
    
    public int loop() {
        int action = -1;
        if (client.active() && client.available() > 0) action = int(client.readString());
        return action;
    }

    public void disconnect() {
        send("disc");
    }
}
