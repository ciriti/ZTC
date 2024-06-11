import 'package:flutter/material.dart';
import 'package:ztc/src/datalayer/daemon2.dart';
import 'constants/app_sizes.dart';
import 'package:ztc/src/datalayer/registration.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZTCHomePage extends ConsumerStatefulWidget {
  const ZTCHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ZTCHomePageState();
}

class ZTCHomePageState extends ConsumerState<ZTCHomePage> {
  final List<String> _log = [];

  void _connect() async {
    setState(() {
      _log.add('Attempting to connect...');
    });

    final IRegistrationAPI client = buildApiClient(
      baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
      authKey: '3735928559',
    );

    var tokenResult = await client.getAuthToken();

    tokenResult.fold(
      (failure) {
        setState(() {
          _log.add('Error: ${failure.message}');
          print('Error: ${failure.message}');
        });
      },
      (authToken) async {
        setState(() {
          _log.add(
              'Token received[$authToken], attempting to connect to daemon...');
        });
        // Connect to the socket
        ref
            .read(daemonConnectionProvider.notifier)
            .connect(int.parse(authToken));
      },
    );
  }

  void _disconnect() async {
    setState(() {
      _log.add('Attempting to disconnect...');
    });
    // Disconnect from the socket
    ref.read(daemonConnectionProvider.notifier).disconnect();
  }

  @override
  Widget build(BuildContext context) {
    final socketState = ref.watch(daemonConnectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZT Client'),
      ),
      body: Padding(
        padding: insets16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Status(status: socketState.last.toString()),
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
