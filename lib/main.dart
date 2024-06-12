import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ztc/src/presentation/pages/ztc_home_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var tempDir = await getTemporaryDirectory();
  print('Please use this directory for the daemon-lite[$tempDir]');

  runApp(
    const ProviderScope(
      child: ZTCApp(),
    ),
  );
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
