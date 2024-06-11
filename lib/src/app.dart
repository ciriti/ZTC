import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ztc/src/datalayer/daemon.dart';
import 'package:ztc/src/datalayer/socket_state.dart';
import 'package:ztc/src/widgets.dart';
import 'constants/app_sizes.dart';
import 'package:ztc/src/datalayer/registration.dart';

class ZTCHomePage extends StatefulWidget {
  const ZTCHomePage({super.key});

  @override
  ZTCHomePageState createState() => ZTCHomePageState();
}

class ZTCHomePageState extends State<ZTCHomePage> {
  final DaemonConnection _daemonConnection = DaemonConnection();
  late StreamSubscription<SocketState> _stateSubscription;
  String _status = 'Disconnected';
  final List<String> _log = [];

  @override
  void initState() {
    super.initState();
    _stateSubscription = _daemonConnection.state.listen((state) {
      setState(() {
        _log.add(state.toString());
        if (state is SocketConnected) {
          _status = 'Connected';
        } else if (state is SocketDisconnected) {
          _status = 'Disconnected';
        } else if (state is SocketError) {
          _status = 'Error: ${state.message}';
        }
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription.cancel();
    _daemonConnection.dispose();
    super.dispose();
  }

  void _connect() async {
    _log.add('Attempting to connect...');

    final IRegistrationAPI client = buildApiClient(
      baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
      authKey: '3735928559',
    );

    var tokenResult = await client.getAuthToken();

    tokenResult.fold(
      (failure) {
        setState(() {
          _log.add('Error: ${failure.message}');
          _status = 'Error: ${failure.message}';
          print('Error: ${failure.message}');
        });
      },
      (authToken) async {
        setState(() {
          _log.add(
              'Token received[$authToken], attempting to connect to daemon...');
        });
        await _daemonConnection.connect(authToken: int.parse(authToken));
      },
    );
  }

  void _disconnect() async {
    _log.add('Attempting to disconnect...');
    await _daemonConnection.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ZT Client'),
      ),
      body: Padding(
        padding: insets16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Status(status: _status),
            gapH20,
            Buttons(onConnect: _connect, onDisconnect: _disconnect),
            gapH20,
            Logs(log: _log),
          ],
        ),
      ),
    );
  }
}
