// ignore_for_file: library_prefixes
library masonite_broadcast_client;

import 'package:masonite_broadcast_client/channels/socket_channel.dart';
import 'package:socket_io_client/socket_io_client.dart' show Socket, io;
import 'package:masonite_broadcast_client/socket_io.dart';

class MasoniteBroadcastClient {
  Socket? socket;
  Map<String, dynamic> config = {};
  String? sessionID;
  Map<String, SocketChannel> channels = {};

  MasoniteBroadcastClient(this.config) {
    if (!config.containsKey('url')) {
      throw Exception('MasoniteBroadcastClient requires a url');
    }
    _connect();
  }

  setExtra(value, callback) {
    socket?.emitWithAck("setExtra", {"extra": value}, ack: callback);
  }

  _connect() {
    socket = io(config["url"], {
      "transports": ["websocket", "polling"],
      "path": "/socket.io",
      "autoConnect": false,
    });

    if (sessionID != null) {
      socket?.auth = {sessionID};
      socket?.connect();
    } else {
      socket?.connect();
    }

    /** Handling Events */
    socket?.on("session", (dynamic response) {
      socket?.auth = {response['sessionID']};
      sessionID = response['sessionID'];
      socket?.userID = response['userID'];
      socket?.connect();
    });

    socket?.on("reconnect", _reconnect);
    socket?.on("disconnect", _disconnect);
    socket?.on("error", _error);
    socket?.on("connect_error", _connectError);

    return socket;
  }

  _reconnect(data) {}

  _disconnect(data) {}

  _error(data) {}

  _connectError(data) {}

  on(event, callback) {
    //
  }

  onAny(event, callback) {
    //
  }

  SocketChannel subscribe(channel) {
    if (!channels.containsKey(channel)) {
      channels[channel] = SocketChannel.connect(socket = socket!, channel = channel, config = config);
    }
    return channels[channel]!;
  }

  onClientConnected(callback) {}

  onClientDisconnected(callback) {}
}
