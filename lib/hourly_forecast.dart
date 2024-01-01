import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temperature;

  const HourlyForecast({
    super.key,
    required this.icon,
    required this.time,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 110,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                maxLines: 1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                temperature,
                style: const TextStyle(
                  fontSize: 10,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
