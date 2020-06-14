import 'dart:convert';
import 'dart:html';

import 'dart:typed_data';

// Create a reference for the required DOM elements
final InputElement nameView = document.getElementById('name-view');
final InputElement textView = document.getElementById('text-view');
final InputElement buttonSend = document.getElementById('send-button');
final InputElement buttonStop = document.getElementById('stop-button');
final label = document.getElementById('status-label');
final chatArea = document.getElementById('chat-area');

final webSocketPath = 'ws://localhost:8181';

/// Connect to the WebSocket server
final webSocket = WebSocket(webSocketPath);
int your_id;
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
      final String message = event.data;
      onStringMessage(message);
    } else if (event.data is ByteBuffer) {
      final buffer = event.data;
      print('Buffer = $buffer');
    } else if (event.data is Blob) {
      Blob blob = event.data;
      print(blob);

      // // var base64String = CryptoUtils.bytesToBase64(blob.toBytes());
      // File file;
      // var fileReader = FileReader();
      // fileReader.readAsDataUrl(blob);

      // ImageElement imageElement = document.createElement('img');
      // imageElement.src = '';
      // chatArea.children.add(imageElement);
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

/// Display message
void onStringMessage(String message) {
  var decodedMessage = jsonDecode(message);
  Map decodedMap;

  if (decodedMessage is Map) {
    decodedMap = decodedMessage;
    // Extract the values for each key

    your_id ??= decodedMap['id'];
    final newMessage = decodedMap['message'];
    if (newMessage == null) {
      return;
    }

    var map;
    var userName;
    var userMessage;
    try {
      map = jsonDecode(newMessage);
      if (map == null) {
        return;
      }
      userName = map['name'];
      int id = decodedMap['id'];
      if (id == your_id) {
        userName = 'You';
      }
      userMessage = map['message'];
    } on FormatException catch (_) {
      userName = 'Chat Server';
      userMessage = newMessage;
      
    }

    // Display message
    chatArea.innerHtml +=
        '<p>$userName says: <strong>$userMessage</strong></p>';

    // Scroll to bottom.
    chatArea.scrollTop = chatArea.scrollHeight;
  } // if
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
    sendText();
  });

  // Send the message and clean the text field
  textView.onKeyPress.listen((KeyboardEvent event) {
    if (event.keyCode == 13) {
      sendText();
    }
  });

  /// Handle the drop event
  /// Using ArrayBuffer
  document.onDrop.listen((event) {
    final file = event.dataTransfer.files[0];
    if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
      final fileReader = FileReader();
      fileReader.readAsArrayBuffer(file);
      fileReader.onLoad.listen((event) {
        if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
          webSocket.send(file);
          print('File send');
          print(file);
        }
      });
    }
  });

  /// Prevent the default behaviour of the dragover event
  document.onDragOver.listen((event) => event.stopImmediatePropagation());
}

/// Send a text message using WebSocket.
void sendText() {
  if (webSocket != null && webSocket.readyState == WebSocket.OPEN) {
    final map = {'name': nameView.value, 'message': textView.value};
    final json = jsonEncode(map);
    webSocket.send(json);

    textView.value = '';
  }
}
