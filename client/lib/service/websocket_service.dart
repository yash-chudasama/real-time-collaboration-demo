import "package:socket_io_client/socket_io_client.dart";

class WebsocketService {
  late final Socket _socketClient;

  WebsocketService() {
    _socketClient = io("http://localhost:3001", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socketClient.onConnect((_) {
      print("Client connected");
    });

    _socketClient.onDisconnect((_) {
      print("Client disconnected");
    });

    _socketClient.onError((data) {
      print("Error while connecting socket client $data");
    });

    _socketClient.connect();
  }

  typing(jsonMap) {
    _socketClient.emit("typing", jsonMap);
  }

  addChangeListener(Function(Map<String, dynamic>) fun) {
    _socketClient.on("changes", (_) {
      return fun(_);
    });
  }
}
