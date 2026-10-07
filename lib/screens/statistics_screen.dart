import 'package:flutter/material.dart';
import '../widgets/stat_card.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        children: const [
          Text(
            'آمار',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'وضعیت اتصال و مصرف اینترنت',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          StatCard(
            title: 'وضعیت اتصال',
            value: 'آماده اتصال',
            icon: Icons.shield_outlined,
          ),
          SizedBox(height: 12),
          StatCard(
            title: 'مصرف امروز',
            value: '0 MB',
            icon: Icons.data_usage_outlined,
          ),
          SizedBox(height: 12),
          StatCard(
            title: 'سرعت فعلی',
            value: '0 KB/s',
            icon: Icons.speed_outlined,
          ),
          SizedBox(height: 12),
          StatCard(
            title: 'پینگ',
            value: '0 ms',
            icon: Icons.network_ping_outlined,
          ),
          SizedBox(height: 20),
          Card(
            color: Color(0xFF111522),
            child: ListTile(
              leading: Icon(
                Icons.bolt_outlined,
                color: Color(0xFF00D9FF),
              ),
              title: Text('تست سرعت'),
              subtitle: Text('بررسی سرعت و کیفیت اتصال'),
              trailing: Icon(Icons.chevron_left),
            ),
          ),
        ],
      ),
    );
  }
}
