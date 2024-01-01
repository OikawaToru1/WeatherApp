import 'package:flutter/material.dart';

class AdditionalinfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const AdditionalinfoBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          width: 25,
        ),
        Icon(
          icon,
          size: 30,
        ),
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w100,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w100),
        ),
      ],
    );
  }
}
