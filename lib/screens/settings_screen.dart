import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import '../widgets/subscription_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        children: [
          const Text(
            'تنظیمات',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'مدیریت NovaVPN',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          const SubscriptionCard(
            plan: 'Free Plan',
            status: 'فعال',
            expiry: 'اعتبار: ۳۰ روز',
          ),
          const SizedBox(height: 20),
          Card(
            color: const Color(0xFF111522),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.apps_outlined,
                    color: Color(0xFF00D9FF),
                  ),
                  title: const Text('VPN برای برنامه‌ها'),
                  subtitle: const Text('انتخاب برنامه‌های تحت VPN'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.palette_outlined,
                    color: Color(0xFF7C4DFF),
                  ),
                  title: const Text('ظاهر برنامه'),
                  subtitle: const Text('تم و نمایش NovaVPN'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(
                    Icons.account_circle_outlined,
                    color: Color(0xFF00D9FF),
                  ),
                  title: const Text('حساب کاربری'),
                  subtitle: const Text('مدیریت حساب و اشتراک'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFF111522),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.volunteer_activism_outlined, color: Color(0xFF00D9FF)),
                  title: const Text('حمایت از NovaVPN (تبلیغ اختیاری)'),
                  subtitle: const Text('با انتخاب شما، صفحه پیشنهادهای تبلیغاتی باز می‌شود'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () async {
                    final uri = Uri.parse('https://asiafilm.org/4/0a72bc9d378be74f04a1ec6cc70cc6e7');
                    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
                    if (!opened && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('باز کردن صفحه تبلیغ ممکن نشد.')),
                      );
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('درباره NovaVPN'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('حریم خصوصی و قوانین'),
                  trailing: const Icon(Icons.chevron_left),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
