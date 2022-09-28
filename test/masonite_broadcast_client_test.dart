import 'package:flutter_test/flutter_test.dart';
import 'package:masonite_broadcast_client/channels/socket_channel.dart';

import 'package:masonite_broadcast_client/masonite_broadcast_client.dart';

void main() {
  test('adds one to input values', () {
    final masoniteBroadcastClient = MasoniteBroadcastClient({
      "url": "http://localhost:3000",
    });
    SocketChannel channel = masoniteBroadcastClient.subscribe("default");

    // expect(calculator.addOne(2), 3);
    // expect(calculator.addOne(-7), -6);
    // expect(calculator.addOne(0), 1);
  });
}
