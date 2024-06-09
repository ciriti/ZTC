import 'package:flutter/material.dart';
import 'package:ztc/src/app.dart';

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
