import 'package:flutter/material.dart';
import 'package:ztc/src/app.dart';
import 'package:ztc/src/datalayer/registration.dart';

void main() async {
  final IRegistrationAPI client = buildApiClient(
    baseUrl: 'https://warp-registration.warpdir2792.workers.dev/',
    authKey: '3735928559',
  );

  var token = await client.getAuthToken();
  token.fold(
    (l) {
      print(l.message);
    },
    (r) {
      print(r);
    },
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
