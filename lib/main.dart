import 'package:flutter/material.dart';

void main() {
  runApp(const NovaVPNApp());
}

class NovaVPNApp extends StatelessWidget {
  const NovaVPNApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NovaVPN',
      theme: ThemeData.dark(),
      home: const Scaffold(
        body: Center(
          child: Text('NOVA VPN'),
        ),
      ),
    );
  }
}
