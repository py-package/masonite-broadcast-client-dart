import 'package:socket_io_client/socket_io_client.dart' as IO;

extension SocketIO on IO.Socket {
  static String? uid;

  set userID(String? value) {
    uid = value;
  }

  String? get userID => uid;
}
