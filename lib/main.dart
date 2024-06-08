import 'package:flutter/material.dart';

void main() {
  runApp(const ZTCApp());
}

class ZTCApp extends StatelessWidget {
  const ZTCApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZT Client',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ZTCHomePage(),
    );
  }
}

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
        title: const Text('VPN Client'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Status(status: _status),
            const SizedBox(height: 20),
            Buttons(onConnect: _connect, onDisconnect: _disconnect),
            const SizedBox(height: 20),
            Logs(log: _log),
          ],
        ),
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final VoidCallback onConnect;
  final VoidCallback onDisconnect;

  const Buttons({
    super.key,
    required this.onConnect,
    required this.onDisconnect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(
          onPressed: onConnect,
          child: const Text('Connect'),
        ),
        ElevatedButton(
          onPressed: onDisconnect,
          child: const Text('Disconnect'),
        ),
      ],
    );
  }
}

class Logs extends StatelessWidget {
  const Logs({
    super.key,
    required List<String> log,
  }) : _log = log;

  final List<String> _log;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ListView.builder(
          itemCount: _log.length,
          itemBuilder: (context, index) {
            return Text(_log[index]);
          },
        ),
      ),
    );
  }
}

class Status extends StatelessWidget {
  const Status({
    super.key,
    required String status,
  }) : _status = status;

  final String _status;

  @override
  Widget build(BuildContext context) {
    return Text(
      'Status: $_status',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
