import 'package:flutter/material.dart';
import '../widgets/server_card.dart';

class ServersScreen extends StatelessWidget {
  const ServersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        children: const [
          Text(
            'سرورها',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'انتخاب و مدیریت سرورهای NovaVPN',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 24),
          ServerCard(
            name: 'Nova Free',
            location: 'رایگان',
            ping: 42,
          ),
          ServerCard(
            name: 'Nova Fast',
            location: 'پرسرعت',
            ping: 28,
          ),
          ServerCard(
            name: 'My Server',
            location: 'سرورهای من',
            ping: 35,
          ),
          SizedBox(height: 8),
          Card(
            color: Color(0xFF111522),
            child: ListTile(
              leading: Icon(
                Icons.add_circle_outline,
                color: Color(0xFF00D9FF),
              ),
              title: Text('افزودن سرور'),
              subtitle: Text('لینک، QR، کلیپ‌بورد یا ورود دستی'),
              trailing: Icon(Icons.chevron_left),
            ),
          ),
        ],
      ),
    );
  }
}
