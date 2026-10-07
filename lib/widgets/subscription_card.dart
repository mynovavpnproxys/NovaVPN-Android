import 'package:flutter/material.dart';

class SubscriptionCard extends StatelessWidget {
  final String plan;
  final String status;
  final String expiry;

  const SubscriptionCard({
    super.key,
    required this.plan,
    required this.status,
    required this.expiry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF24134D),
            Color(0xFF102D46),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0x337C4DFF),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.workspace_premium_outlined,
                color: Color(0xFF00D9FF),
              ),
              SizedBox(width: 10),
              Text(
                'اشتراک NovaVPN',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            plan,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            status,
            style: const TextStyle(
              color: Color(0xFF00D9FF),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            expiry,
            style: const TextStyle(
              color: Colors.white60,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
