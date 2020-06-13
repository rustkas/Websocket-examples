import 'dart:html';

WebSocket webSocket;

void listen_webSocket() {
  webSocket = WebSocket('wss://echo.websocket.org/');
  //check WebSocket existence

  if (webSocket != null) {
    // add message listener

    webSocket.onOpen.listen((Event event) {
      print('Connection established');

      // Initialize any resources here and display some user-friendly messages.
      final label = document.getElementById('status-label');
      label.innerHtml = 'Connection established!';

      // send test message to the server
      webSocket.send('Test message');

      InputElement textView = document.getElementById('text-view');
      textView.value = 'Message for sending';
    });
    webSocket.onMessage.listen((MessageEvent event) {
      if (event.data is String) {
        // If the server has sent text data, then display it.
        var label = document.getElementById('status-label');
        label.innerHtml = event.data;
      }
    });
    webSocket.onClose.listen((CloseEvent event) {
      print('Connection closed.');

      final code = event.code;
      final reason = event.reason;
      final wasClean = event.wasClean;
      final label = document.getElementById('status-label');

      if (wasClean) {
        label.text = 'Connection closed normally.';
      } else {
        label.text = 'Connection closed with message $reason (Code: $code)';
      }
      InputElement textView = document.getElementById('text-view');
      textView.value = '';
    });

   
  } else {
    print('WebSocket not connected, message does not sent');
  }
}
