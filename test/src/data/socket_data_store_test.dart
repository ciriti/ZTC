import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ztc/src/data/socket_data_store.dart';
import 'package:ztc/src/utils/ext.dart';

class MockSocket extends Mock implements Socket {}

class MockStreamSubscription<T> extends Mock implements StreamSubscription<T> {}

void main() {
  late SocketDataStore socketDataStore;
  late MockSocket mockSocket;
  late MockStreamSubscription<Uint8List> mockSubscription;

  setUp(() {
    mockSocket = MockSocket();
    socketDataStore = SocketDataStore(socket: mockSocket);
    mockSubscription = MockStreamSubscription<Uint8List>();
  });

  test('connectSocket should successfully connect and receive data', () async {
    // Arrange
    final successCallback = expectAsync1((String jsonString) {
      expect(jsonString, '{"status":"success","message":"connected"}');
    });

    final failureCallback = expectAsync1((String error) {}, count: 0);

    when(() => mockSocket.listen(
          any(),
          onError: any(named: 'onError'),
          onDone: any(named: 'onDone'),
          cancelOnError: any(named: 'cancelOnError'),
        )).thenAnswer((invocation) {
      final dataCallback =
          invocation.positionalArguments[0] as void Function(Uint8List);
      String jsonString = '{"status":"success","message":"connected"}';
      List<int> jsonPayloadBytes = utf8.encode(jsonString);
      int payloadSize = jsonPayloadBytes.length;
      List<int> sizeBytes = payloadSize.toBytes();
      List<int> data = sizeBytes + jsonPayloadBytes;
      dataCallback(Uint8List.fromList(data));
      return mockSubscription;
    });

    // Act
    await socketDataStore.connectSocket(successCallback, failureCallback);

    // Assert
    verify(() => mockSocket.listen(
          any(),
          onError: any(named: 'onError'),
          onDone: any(named: 'onDone'),
          cancelOnError: any(named: 'cancelOnError'),
        )).called(1);
  });
}
