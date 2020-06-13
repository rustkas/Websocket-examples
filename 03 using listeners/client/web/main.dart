import 'dart:async';
import 'dart:html';

import 'dart:math';

void main() {
  InputElement buttonSend = document.getElementById('send-button');
  buttonSend.onClick.listen((event) {
    print('Button clicked!');
  });

  //check WebSocket existence

  final webSocket = WebSocket('wss://echo.websocket.org/');

  if (webSocket != null) {
    // add message listener

    webSocket.onOpen.listen((Event event) {
      print('Connection established');

      // Initialize any resources here and display some user-friendly messages.
      final label = document.getElementById('status-label');
      label.innerHtml = 'Connection established!';

      // send test message to the server
      webSocket.send('Test message');
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
    });

    // Add ramdom behaviour
    final random = Random();
    final newValue = random.nextInt(1);
    print('newValue = $newValue');
    switch (1) {
      case 0:
        // close connection after 3 seconds
        Timer(Duration(seconds: 3), () {
          webSocket.close();
        });
        break;
      case 1:
        // close connection after 3 seconds
        Timer(Duration(seconds: 3), () {
          // close operation with that parameters is not supported
          //
          // webSocket.close(1, 'Do it as a test');
          //
          // The code must be either 1000, or between 3000 and 4999. 1 is neither.
          
          webSocket.close(1000, 'Do it as a test');
          // more informaton about close code is here https://developer.mozilla.org/en-US/docs/Web/API/CloseEvent
        });
        break;
      default:
    }
  } else {
    print('WebSocket not connected, message does not sent');
  }
}
//webdev serve
