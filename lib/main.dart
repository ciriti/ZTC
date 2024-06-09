import 'package:flutter/material.dart';
import 'package:ztc/src/app.dart';
import 'package:ztc/src/features/authentication/registration.dart';

void main() {
  final IRegistrationAPI registrationAPI = buildApiClient(
    baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
    authKey: '3735928559',
  );
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
