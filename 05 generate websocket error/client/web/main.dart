import 'dart:html';

import 'package:client/webSocket.dart';

void main() {
  // Find the text view and the button.
  InputElement textView = document.getElementById('text-view');
  InputElement buttonSend = document.getElementById('send-button');
  buttonSend.onClick.listen((event) {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(textView.value);
    }
  });
  listen_webSocket();
}
//webdev serve
