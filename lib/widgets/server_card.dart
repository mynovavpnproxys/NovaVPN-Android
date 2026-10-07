import 'package:flutter/material.dart';

class ServerCard extends StatelessWidget {
  final String name;
  final String location;
  final int ping;

  const ServerCard({
    super.key,
    required this.name,
    required this.location,
    required this.ping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111522),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0x227C4DFF),
        ),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0x227C4DFF),
            child: Icon(
              Icons.public,
              color: Color(0xFF00D9FF),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$ping ms',
            style: const TextStyle(
              color: Color(0xFF00D9FF),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
