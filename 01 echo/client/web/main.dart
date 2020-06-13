import 'dart:html';

import 'package:echo/websocket.dart';

void main() {
  final DivElement output = document.getElementById('output');
  testWebSocket(output);
}
//webdev serve
