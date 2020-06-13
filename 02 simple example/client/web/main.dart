import 'dart:html';

void main() {
  InputElement buttonSend = document.getElementById('send-button');
  buttonSend.onClick.listen((event) {
    print('Button clicked!');
  });

  //check WebSocket existence

  final webSocket = WebSocket('wss://echo.websocket.org/');
  final data = 'Hello!';

  if (webSocket != null) {
    // add message listener
    webSocket.onMessage.listen((MessageEvent e) {
      print('Get data = ${e.data}');
      webSocket.close();
    });
    webSocket.onOpen.listen((event) {
      webSocket.send(data);
      print('WebSocket worked properly');
    });
  } else {
    print('WebSocket not connected, message $data not sent');
    return;
  }
}
//webdev serve
