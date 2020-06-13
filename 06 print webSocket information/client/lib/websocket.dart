import 'dart:html';

const wsUri = 'wss://echo.websocket.org/';
WebSocket webSocket;

/// Element container
Element container;
void printWebSocketInfo(Element output) {
  container = output;
  if (container == null) {
    throw Exception('Container element is not defined');
  }

  webSocket = WebSocket(wsUri);

  if (webSocket != null
      //&& webSocket.readyState == WebSocket.OPEN
      ) {
    webSocket.onOpen.listen((event) => onOpen(event));
    webSocket.onClose.listen((event) => onClose(event));
    webSocket.onError.listen((event) => onError(event));
  } else {
    print('WebSocket not connected');
  }
}

void onOpen(Event event) {
  {
    //url
    // print the WebSocket URL
    final span = SpanElement();
    span.innerText = 'url: ${webSocket.url}';
    writeToScreen(span);
    {
      //protocol
      //print protocol used by the server
      final span = SpanElement();
      span.innerText = 'protocol: ${webSocket.protocol}';
      writeToScreen(span);
    }
    {
      //readyState
      //print state of the connection
      final span = SpanElement();
      span.innerText = 'readyState: ${webSocket.readyState}';
      writeToScreen(span);
    }
    {
      // bufferedAmount
      // print the total number of bytes that were queued when the send()
      // method was called
      final span = SpanElement();
      span.innerText = 'bufferedAmount: ${webSocket.bufferedAmount}';
      writeToScreen(span);
    }
    {
      // binaryType
      // print the binary data format we received when the onMessage event was 
      // raised
      final span = SpanElement();
      span.innerText = 'binaryType: ${webSocket.binaryType}';
      writeToScreen(span);
    }
  }
}

void onClose(CloseEvent event) {
  final span = SpanElement();
  span.innerText = 'DISCONNECTED';
  writeToScreen(span);
}

void onError(Event event) {
  final span = SpanElement();
  span.innerText = 'ERROR: ${event.type}';
  span.style.color = 'red';
  writeToScreen(span);
}

void writeToScreen(Element element) {
  var p = document.createElement('p');
  p.style.wordWrap = 'break-word';
  p.children.add(element);
  container.children.add(p);
}
