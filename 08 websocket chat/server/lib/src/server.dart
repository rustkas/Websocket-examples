import 'dart:convert';
import 'dart:io';

const int port = 8181;

final connections = <int, WebSocket>{};

/// Utf8 encoder instance
const utf8 = Utf8Encoder();

HttpServer server;

Future<void> webSocketServer() async {
  try {
    server = await HttpServer.bind('127.0.0.1', port);
    server.transform(WebSocketTransformer()).listen(onWebSocketData);
    print('${server.address.address}:${server.port} listening...');
  } catch (e) {
    print('Couldn\'t bind to port $port: $e');
  }
}

/// WebSocker listener
void onWebSocketData(WebSocket client) async {
  final key = client.hashCode;
  if (!connections.containsKey(key)) {
    client.listen((message) {
      if (message is String) {
        final map = <String, dynamic>{
          'id': client.hashCode,
          'message': message
        };
        for (var clientConnection in connections.values) {
          clientConnection.add(jsonEncode(map));
        } // for

      } else {
        print(message.runtimeType);
        for (var clientConnection in connections.values) {
          //clientConnection.a.add(jsonEncode(map));
        } // for
      } // if
    }, onError: (o, e) {
      print(o);
      print('---------------');
      print(e);
    }, onDone: () {
      // connection is closed
      connections.remove(key);
      final map = <String, dynamic>{
        'id': client.hashCode,
        'message': '<i>${client.hashCode}' ' left the chat room.</i>'
      };
      for (var clientConnection in connections.values) {
        clientConnection.add(jsonEncode(map));
      }
    });

    // inform new connection about your server id
    {
      client.add(jsonEncode(<String, int>{'id': key}));

      client.add(jsonEncode(<String, dynamic>{
        'id': client.hashCode,
        'message': '''
        <br>
        <i>Enjoy chatting!</i><br>
        <i>Your <b>Id</b> is ${client.hashCode}</i><br>
        You have just joined the conversation.
        '''
      }));
    }

    // Inform others about new connection
    final map = <String, dynamic>{
      'id': client.hashCode,
      'message': '<i>${client.hashCode} joined the conversation.</i>'
    };
    for (var clientConnection in connections.values) {
      clientConnection.add(jsonEncode(map));
    }

    connections[key] = client;
  } // if
}
