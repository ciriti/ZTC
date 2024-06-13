import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/data/bytes_converter.dart';
import 'package:ztc/src/utils/ext.dart';

class SocketDataStore {
  final BytesConverter bytesConverter;

  SocketDataStore(this.bytesConverter);

  Future<Map<String, dynamic>> sendRequest(
      Map<String, dynamic> requestPayload) async {
    final socket = await _connectToSocket();

    try {
      String jsonPayload = jsonEncode(requestPayload);
      List<int> payloadBytes = utf8.encode(jsonPayload);
      int payloadSize = payloadBytes.length;
      socket.add(payloadSize.toBytes());
      socket.add(payloadBytes);

      // Read the response size
      final jsonResponse = await bytesConverter.readBytes(socket);
      print('Received response: $jsonResponse');

      return jsonResponse;
    } finally {
      socket.close();
    }
  }

  Future<Socket> _connectToSocket() async {
    var tempDir = await getTemporaryDirectory();
    String socketPath = "${tempDir.path}/daemon-lite";
    final socket = await Socket.connect(
      InternetAddress(socketPath, type: InternetAddressType.unix),
      0,
    );
    return socket;
  }
}
