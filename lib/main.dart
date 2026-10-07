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
      home: const NovaHomePage(),
    );
  }
}

class NovaHomePage extends StatelessWidget {
  const NovaHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NOVA VPN'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'اتصال امن و سریع',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            label: 'داشبورد',
          ),
          NavigationDestination(
            icon: Icon(Icons.dns_outlined),
            label: 'سرورها',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'آمار',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            label: 'تنظیمات',
          ),
        ],
      ),
    );
  }
}
