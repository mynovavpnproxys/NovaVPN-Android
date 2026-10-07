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
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        children: [
          const Text(
            'NOVA VPN',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            connected ? 'اتصال امن برقرار است' : 'اینترنت آزاد و امن',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: NovaConnectButton(
              connected: connected,
              onPressed: () {
                setState(() {
                  connected = !connected;
                });
              },
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF111522),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0x227C4DFF),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  connected
                      ? Icons.shield
                      : Icons.shield_outlined,
                  color: const Color(0xFF00D9FF),
                  size: 32,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
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
                ),
                Text(
                  connected ? 'فعال' : 'خاموش',
                  style: TextStyle(
                    color: connected
                        ? const Color(0xFF00D9FF)
                        : Colors.white54,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              NovaInfoCard(
                title: 'اعتبار اشتراک',
                value: '۳۰ روز',
                icon: Icons.event_available_outlined,
              ),
              SizedBox(width: 12),
              NovaInfoCard(
                title: 'سرعت فعلی',
                value: '۰ KB/s',
                icon: Icons.speed_outlined,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF111522),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.public,
                  color: Color(0xFF7C4DFF),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'سرور انتخابی: Nova Free',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(Icons.chevron_left),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
