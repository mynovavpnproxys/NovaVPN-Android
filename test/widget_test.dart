import 'package:flutter_test/flutter_test.dart';
import 'package:novavpn/main.dart';

void main() {
  testWidgets('NovaVPN app renders navigation shell', (tester) async {
    await tester.pumpWidget(const NovaVPNApp());
    expect(find.text('NOVA VPN'), findsOneWidget);
    expect(find.text('داشبورد'), findsOneWidget);
  });
}
