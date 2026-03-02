import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  final String label;
  final Widget value;
  final Color color;

  const StatusRow({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
        value,
      ],
    );
  }
}
