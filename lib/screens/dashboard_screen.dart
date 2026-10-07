import 'package:flutter/material.dart';
import '../widgets/nova_connect_button.dart';
import '../widgets/nova_info_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool connected = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          children: [
            const Text(
              'NOVA VPN',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              connected ? 'اتصال برقرار است' : 'اتصال امن و سریع',
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 32),
            NovaConnectButton(
              connected: connected,
              onPressed: () {
                setState(() {
                  connected = !connected;
                });
              },
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFF111522),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.shield_outlined,
                    color: Color(0xFF00D9FF),
                    size: 30,
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'حالت فعال',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        connected ? 'VPN فعال' : 'آماده اتصال',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                NovaInfoCard(
                  title: 'اعتبار',
                  value: '۳۰ روز',
                  icon: Icons.event_available_outlined,
                ),
                SizedBox(width: 12),
                NovaInfoCard(
                  title: 'سرعت',
                  value: '۰ KB/s',
                  icon: Icons.speed_outlined,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
