import 'dart:html';

const wsUri = 'wss://echo.websocket.org/';
WebSocket webSocket;

/// Element container
Element container;
void testWebSocket(Element output) {
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
    webSocket.onMessage.listen((event) => onMessage(event));
    webSocket.onError.listen((event) => onError(event));
  } else {
    print('WebSocket not connected');
  }
}

void onOpen(Event event) {
  final span = SpanElement();
  span.innerText = 'CONNECTED';
  span.style.color = 'green';
  writeToScreen(span);
  doSend('WebSocket rocks');
}

void onClose(CloseEvent event) {
  final span = SpanElement();
  span.innerText = 'DISCONNECTED';
  writeToScreen(span);
}

void onMessage(MessageEvent event) {
  final span = SpanElement();
  span.innerText = 'RESPONSE: ${event.data}';
  span.style.color = 'blue';
  writeToScreen(span);
  webSocket.close();
}

void onError(Event event) {
  final span = SpanElement();
  span.innerText = 'ERROR: ${event.type}';
  span.style.color = 'red';
  writeToScreen(span);
}

void doSend(String message) {
  final span = SpanElement();
  span.innerText = 'SENT: $message';
  writeToScreen(span);
  webSocket.send(message);
}

void writeToScreen(Element element) {
  var p = document.createElement('p');
  p.style.wordWrap = 'break-word';
  p.children.add(element);
  container.children.add(p);
}
