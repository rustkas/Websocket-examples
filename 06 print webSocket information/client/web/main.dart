import 'dart:html';

import 'package:info/websocket.dart';

void main() {
  final DivElement output = document.getElementById('output');
  printWebSocketInfo(output);
}
//webdev serve
