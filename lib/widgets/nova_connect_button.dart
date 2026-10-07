import 'package:flutter/material.dart';

class NovaConnectButton extends StatelessWidget {
  final bool connected;
  final VoidCallback onPressed;

  const NovaConnectButton({
    super.key,
    required this.connected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C4DFF),
              Color(0xFF00D9FF),
            ],
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x667C4DFF),
              blurRadius: 35,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Text(
            connected ? 'قطع اتصال' : 'اتصال',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
