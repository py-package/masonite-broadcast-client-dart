// ignore_for_file: library_prefixes

import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketChannel {
  IO.Socket? socket;
  Map<String, dynamic> config = {};
  String channel = "default";
  final Map<String, dynamic> _listeners = {};

  static connect(IO.Socket socket, String name, Map<String, dynamic> config) {
    SocketChannel channel = SocketChannel();
    channel._init(socket = socket, name = name, config = config);
    return channel;
  }

  _init(IO.Socket socket, String name, Map<String, dynamic> config) {
    this.socket = socket;
    channel = name;
    this.config = config;
    subscribe();
  }

  void subscribe() {
    socket?.emit("subscribe", {channel: channel});

    Map<String, dynamic> data = {
      "channel_name": channel,
      "socket_id": socket?.auth?.sessionID,
    };

    // fetch('/pusher/auth', {
    //     method: 'POST',
    //     headers: {
    //         'Content-Type': 'application/json',
    //     },
    //     body: JSON.stringify(data)
    // }).then((response) => {
    //     if (response.status === 200) return response.json();
    //     return false;
    // }).catch((error) => {
    //     //! ignore
    // }).then((data) => {
    //     if (data !== false) {
    //         this.socket.emit("subscribe", {
    //             channel: `private-${this.channel}`
    //         })
    //     }
    // });
  }

  void unsubscribe() {
    socket?.emit("unsubscribe", {
      channel: channel,
    });
  }

  SocketChannel whisper(event, data) {
    socket?.emit("whisper", {
      channel: channel,
      event: event,
      data: data,
    });
    return this;
  }

  SocketChannel speak(event, data) {
    socket?.emit("speak", {
      channel: channel,
      event: event,
      data: data,
    });
    return this;
  }

  SocketChannel listen(String event, Function callback) {
    if (!_listeners[event]) {
      _listeners[event] = (data) => {callback(data)};
      socket?.on(event, _listeners[event]);
    }
    return this;
  }

  listenForWhisper(event, callback) {
    socket?.on("whisper:$event", callback);
  }

  emit(event, message) {
    socket?.emit("emit", {
      "channel": channel,
      "event": event,
      "data": message,
    });
  }

  broadcast(event, message) {
    socket?.emit("broadcast", {
      "channel": channel,
      "event": event,
      "data": message,
    });
  }
}
