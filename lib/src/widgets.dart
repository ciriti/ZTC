import 'package:flutter/material.dart';

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
