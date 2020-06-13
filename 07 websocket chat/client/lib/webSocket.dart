import 'dart:convert';
import 'dart:html';

// Create a reference for the required DOM elements
final InputElement textView = document.getElementById('text-view');
final InputElement buttonSend = document.getElementById('send-button');
final InputElement buttonStop = document.getElementById('stop-button');
final label = document.getElementById('status-label');
final chatArea = document.getElementById('chat-area');

final webSocketPath = 'ws://localhost:8181';

/// Connect to the WebSocket server
final webSocket = WebSocket(webSocketPath);

void run() {
  // check if the websocket functionality supported
  if (!WebSocket.supported) {
    return;
  }
  addWebSocketListeners();
  addDomElementListeners();
}

void addWebSocketListeners() {
  if (webSocket == null) {
    print('Can not connect to the web socket $webSocketPath');
    return;
  }
  buttonSend.disabled = true;
  buttonStop.disabled = true;
  textView.disabled = true;
  int webSocketServerId;

  // WebSocket onOpen event
  webSocket.onOpen.listen((Event event) {
    label.innerHtml = 'Connection open';
    buttonSend.disabled = false;
    buttonStop.disabled = false;
    textView.disabled = false;
  });

  // WebSocket onMessage event
  webSocket.onMessage.listen((MessageEvent event) {
    if (event.data is String) {
      // Display message
      String message = event.data;
      // print(message);
      var decodedMessage = jsonDecode(message);
      Map decodedMap;

      if (decodedMessage is Map) {
        decodedMap = decodedMessage;
        if (!(decodedMap['id'] is int)) {
          throw Exception('Id type is ${decodedMap['id'].runtimeType}, value = ${decodedMap['id']}');
        }
        int id = decodedMap['id'];
        webSocketServerId ??= id;

        if (webSocketServerId == null) {
          throw Exception('webSocketServerId is null');
        }

        var idText = id == webSocketServerId ? 'You' : '$id';
        // print('idText = $idText; webSocketId = $webSocketServerId, id = $id');
        message = decodedMap['message'];
        if (null != message) {
          message = '<strong>$idText</strong> say: $message';

          chatArea.innerHtml += '<p>$message</p>';
          // Scroll to bottom
          chatArea.scrollTop = chatArea.scrollHeight;
        }
      }
    }
  });

  // WebSocket onClose event
  webSocket.onClose.listen((CloseEvent event) {
    var code = event.code;
    var reason = event.reason;
    var wasClean = event.wasClean;

    if (wasClean) {
      label.innerHtml = 'Connection closed normally.';
    } else {
      label.innerHtml =
          'Connection closed with message: $reason  (Code: $code)';
    }
    buttonSend.disabled = true;
    textView.disabled = true;
    buttonStop.disabled = true;
  });

  //WebSocket onError event
  webSocket.onError.listen((event) {
    label.innerHtml = 'Error: $event';
  });
}

void addDomElementListeners() {
  // Disconnect and close the connection
  buttonStop.onClick.listen((_) {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.close();
    }
  });

  // Send the message and clean the text field
  buttonSend.onClick.listen((_) {
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      webSocket.send(textView.value);
      textView.value = '';
    }
  });

  // Send the message and clean the text field
  textView.onKeyPress.listen((KeyboardEvent event) {
    if (event.keyCode == 13) {
      if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
        webSocket.send(textView.value);
        textView.value = '';
      }
    }
  });
}
