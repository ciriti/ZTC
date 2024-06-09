import 'package:flutter/material.dart';
import 'package:ztc/src/widgets.dart';
import 'constants/app_sizes.dart';

class ZTCHomePage extends StatefulWidget {
  const ZTCHomePage({super.key});

  @override
  ZTCHomePageState createState() => ZTCHomePageState();
}

class ZTCHomePageState extends State<ZTCHomePage> {
  String _status = 'Disconnected';
  final List<String> _log = [];

  void _connect() {
    setState(() {
      _log.add('Attempting to connect...');
      _status = 'Connected';
      _log.add('Connection successful! Daemon status: Connected');
    });
  }

  void _disconnect() {
    setState(() {
      _log.add('Attempting to disconnect...');
      _status = 'Disconnected';
      _log.add('Disconnection successful! Daemon status: Disconnected');
    });
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
