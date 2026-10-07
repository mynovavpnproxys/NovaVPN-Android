import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/servers_screen.dart';
import 'screens/statistics_screen.dart';
import 'screens/settings_screen.dart';
import 'theme/nova_theme.dart';

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
      theme: NovaTheme.dark(),
      home: const NovaNavigation(),
    );
  }
}

class NovaNavigation extends StatefulWidget {
  const NovaNavigation({super.key});

  @override
  State<NovaNavigation> createState() => _NovaNavigationState();
}

class _NovaNavigationState extends State<NovaNavigation> {
  int currentIndex = 0;

  final screens = const [
    DashboardScreen(),
    ServersScreen(),
    StatisticsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'داشبورد',
          ),
          NavigationDestination(
            icon: Icon(Icons.dns_outlined),
            selectedIcon: Icon(Icons.dns),
            label: 'سرورها',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'آمار',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'تنظیمات',
          ),
        ],
      ),
    );
  }
}
