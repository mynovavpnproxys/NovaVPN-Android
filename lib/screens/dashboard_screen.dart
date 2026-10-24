import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../models/nova_server.dart';
import '../services/nova_vpn_engine.dart';
import '../services/server_repository.dart';
import '../widgets/nova_connect_button.dart';
import '../widgets/nova_info_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final NovaVpnEngine _engine = NovaVpnEngine();
  final ServerRepository _repository = ServerRepository();
  List<NovaServer> _servers = [];
  String? _selectedId;
  bool _connected = false;
  bool _busy = false;
  String? _error;

  NovaServer? get _selectedServer {
    for (final server in _servers) { if (server.id == _selectedId) return server; }
    return _servers.isEmpty ? null : _servers.first;
  }
  @override void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final servers = await _repository.loadServers();
      final connected = await _engine.isConnected;
      if (!mounted) return;
      setState(() { _servers = servers; _selectedId = servers.isEmpty ? null : servers.first.id; _connected = connected; });
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'موتور VPN آماده نیست. لطفاً بعداً دوباره تلاش کنید.');
    }
  }

  Future<bool> _confirmVpnDisclosure() async {
    final accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('اجازه و شفاف‌سازی اتصال VPN'),
        content: const Text(
          'با اتصال، ترافیک شبکهٔ دستگاه از سرور انتخاب‌شده عبور می‌کند. '
          'اپراتور آن سرور ممکن است فراداده‌های اتصال را پردازش کند. '
          'فقط از کانفیگ و سروری استفاده کنید که به آن اعتماد دارید. '
          'برای شروع تونل VPN، اندروید نیز اجازهٔ جداگانه درخواست می‌کند.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('انصراف'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('می‌پذیرم و ادامه می‌دهم'),
          ),
        ],
      ),
    );
    return accepted == true;
  }

  Future<void> _toggleConnection() async {
    if (_busy) return;
    if (!_connected) {
      final consent = await _confirmVpnDisclosure();
      if (!consent || !mounted) return;
    }
    final server = _selectedServer;
    if (!_connected && server == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ابتدا از بخش سرورها یک کانفیگ معتبر وارد کنید.')));
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      final result = _connected ? await _engine.disconnect() : await _engine.connect(server!);
      if (!mounted) return;
      setState(() => _connected = result ? !_connected : _connected);
      if (!result) setState(() => _error = 'اتصال برقرار نشد. کانفیگ و دسترسی VPN را بررسی کنید.');
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _connected = false;
        _error = error is FormatException ? error.message.toString() : 'اتصال برقرار نشد. کانفیگ سرور را بررسی کنید.';
      });
    } finally { if (mounted) setState(() => _busy = false); }
  }

  @override Widget build(BuildContext context) {
    final server = _selectedServer;
    return SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 20), children: [
      Center(child: SvgPicture.asset('assets/nova_logo.svg', width: 148, height: 148, semanticsLabel: 'NOVA VPN logo')),
      const SizedBox(height: 10),
      const Text('NOVA VPN', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
      const SizedBox(height: 6),
      Text(_busy ? 'در حال انجام عملیات...' : (_connected ? 'اتصال امن برقرار است' : 'اینترنت آزاد و امن'), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 14)),
      const SizedBox(height: 30),
      Center(child: Opacity(opacity: _busy ? 0.65 : 1, child: NovaConnectButton(connected: _connected, onPressed: _toggleConnection))),
      if (_busy) ...[const SizedBox(height: 16), const Center(child: CircularProgressIndicator())],
      if (_error != null) ...[
        const SizedBox(height: 16),
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0xFF3A1C2A), borderRadius: BorderRadius.circular(12)), child: Text(_error!, style: const TextStyle(color: Colors.white))),
      ],
      const SizedBox(height: 28),
      Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFF111522), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0x227C4DFF))), child: Row(children: [
        Icon(_connected ? Icons.shield : Icons.shield_outlined, color: const Color(0xFF00D9FF), size: 32),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('وضعیت تونل', style: TextStyle(color: Colors.white60, fontSize: 13)),
          const SizedBox(height: 4),
          Text(_connected ? 'VPN فعال' : 'آماده اتصال', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ])),
        Text(_connected ? 'فعال' : 'خاموش', style: TextStyle(color: _connected ? const Color(0xFF00D9FF) : Colors.white54, fontWeight: FontWeight.bold)),
      ])),
      const SizedBox(height: 16),
      Row(children: [
        Expanded(child: NovaInfoCard(title: 'سرورهای ذخیره‌شده', value: _servers.length.toString(), icon: Icons.dns_outlined)),
        const SizedBox(width: 12),
        Expanded(child: NovaInfoCard(title: 'وضعیت موتور', value: _connected ? 'متصل' : 'آماده', icon: Icons.speed_outlined)),
      ]),
      const SizedBox(height: 16),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14), decoration: BoxDecoration(color: const Color(0xFF111522), borderRadius: BorderRadius.circular(18)), child: Row(children: [
        const Icon(Icons.public, color: Color(0xFF7C4DFF)),
        const SizedBox(width: 12),
        Expanded(child: DropdownButtonHideUnderline(child: DropdownButton<String>(
          isExpanded: true, value: server?.id, hint: const Text('ابتدا سرور اضافه کنید'), dropdownColor: const Color(0xFF111522),
          items: _servers.map((item) => DropdownMenuItem(value: item.id, child: Text('${item.name} · ${item.protocol}', overflow: TextOverflow.ellipsis))).toList(),
          onChanged: _connected || _busy ? null : (id) => setState(() => _selectedId = id),
        ))),
      ])),
    ]));
  }
}
