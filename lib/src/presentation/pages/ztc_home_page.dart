import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ztc/src/data/daemon_connection_notifier.dart';
import 'package:ztc/src/data/log_manager_provider.dart';
import 'package:ztc/src/data/socket_state.dart';
import 'package:ztc/src/data/timer_manager_provider.dart';
import '../../utils/app_sizes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZTCHomePage extends ConsumerStatefulWidget {
  const ZTCHomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ZTCHomePageState();
}

class ZTCHomePageState extends ConsumerState<ZTCHomePage> {
  void _connect() async {
    ref.read(daemonConnectionProvider.notifier).connect();
  }

  void _disconnect() async {
    // Disconnect from the socket
    ref.read(daemonConnectionProvider.notifier).disconnect();
  }

  @override
  void initState() {
    super.initState();
    final timeManager = ref.read(timerManagerProvider);
    timeManager.startLogging(() {
      ref.read(daemonConnectionProvider.notifier).getStatus();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketState = ref.watch(daemonConnectionProvider);
    final log = ref.watch(logManagerProvider).log;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZT Client'),
      ),
      body: Padding(
        padding: insets16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Status(status: _getStatus(socketState)),
            gapH20,
            Buttons(onConnect: _connect, onDisconnect: _disconnect),
            gapH20,
            Logs(log: log),
          ],
        ),
      ),
    );
  }

  String _getStatus(SocketState socketState) {
    if (socketState is SocketError) {
      return "Error";
    }
    return socketState.toString();
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

class Logs extends StatefulWidget {
  const Logs({
    super.key,
    required List<String> log,
  }) : _log = log;

  final List<String> _log;

  @override
  State<Logs> createState() => _LogsState();
}

class _LogsState extends State<Logs> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void didUpdateWidget(Logs oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

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
          controller: _scrollController,
          itemCount: widget._log.length,
          itemBuilder: (context, index) {
            return Text(widget._log[index]);
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
