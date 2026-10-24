import 'package:flutter/material.dart';
import '../models/nova_server.dart';
import '../services/import_manager.dart';
import '../services/server_repository.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({super.key});
  @override State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  final _repository = ServerRepository();
  final _importManager = ImportManager();
  List<NovaServer> _servers = [];
  bool _loading = true;

  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final servers = await _repository.loadServers();
    if (!mounted) return;
    setState(() { _servers = servers; _loading = false; });
  }

  Future<void> _addServer() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final input = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('افزودن کانفیگ'),
        content: Form(key: formKey, child: TextFormField(
          controller: controller, autofocus: true, maxLines: 5, minLines: 3,
          decoration: const InputDecoration(hintText: 'لینک VLESS، VMess، Trojan، Shadowsocks، Hysteria2 یا TUIC را وارد کنید', border: OutlineInputBorder()),
          validator: (value) => (value == null || value.trim().isEmpty) ? 'لینک کانفیگ را وارد کنید' : null,
        )),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('لغو')),
          FilledButton(onPressed: () { if (formKey.currentState!.validate()) Navigator.pop(context, controller.text.trim()); }, child: const Text('بررسی و ذخیره')),
        ],
      ),
    );
    controller.dispose();
    if (input == null || !mounted) return;
    final server = _importManager.parse(input);
    if (server == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('لینک پشتیبانی نمی‌شود یا آدرس و پورت آن معتبر نیست.')));
      return;
    }
    final config = _importManager.toSingBoxConfig(server);
    if (config == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('این کانفیگ فعلاً قابل تبدیل به تنظیمات موتور نیست.')));
      return;
    }
    final updated = [..._servers.where((item) => item.rawConfig != server.rawConfig), server];
    await _repository.saveServers(updated);
    if (!mounted) return;
    setState(() => _servers = updated);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('کانفیگ با موفقیت ذخیره شد.')));
  }

  Future<void> _removeServer(NovaServer server) async {
    final updated = _servers.where((item) => item.id != server.id).toList();
    await _repository.saveServers(updated);
    if (mounted) setState(() => _servers = updated);
  }

  @override Widget build(BuildContext context) => SafeArea(
    child: RefreshIndicator(onRefresh: _load, child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      children: [
        const Text('سرورها', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('کانفیگ‌های خودت را وارد و مدیریت کن', style: TextStyle(color: Colors.white60, fontSize: 14)),
        const SizedBox(height: 24),
        FilledButton.icon(onPressed: _addServer, icon: const Icon(Icons.add), label: const Text('افزودن کانفیگ')),
        const SizedBox(height: 16),
        if (_loading) const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator())),
        if (!_loading && _servers.isEmpty) Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: const Color(0xFF111522), borderRadius: BorderRadius.circular(18)),
          child: const Column(children: [Icon(Icons.dns_outlined, size: 42, color: Color(0xFF00D9FF)), SizedBox(height: 12), Text('هنوز کانفیگی ذخیره نشده'), SizedBox(height: 6), Text('با دکمه بالا لینک سرور خودت را اضافه کن.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white60))]),
        ),
        ..._servers.map((server) => Card(
          color: const Color(0xFF111522),
          child: ListTile(
            leading: const Icon(Icons.dns, color: Color(0xFF00D9FF)),
            title: Text(server.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text('${server.protocol} · ${server.address}:${server.port}', maxLines: 2, overflow: TextOverflow.ellipsis),
            trailing: IconButton(icon: const Icon(Icons.delete_outline), tooltip: 'حذف سرور', onPressed: () => _removeServer(server)),
          ),
        )),
      ],
    )),
  );
}
