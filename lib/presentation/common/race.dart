import 'package:flutter/material.dart';

import 'horse_option.dart';

class Race extends StatelessWidget {
  final int raceNumber;
  final int selectedHorse;
  final List<int> horses;

  const Race({
    Key? key,
    required this.raceNumber,
    this.selectedHorse = -1,
    this.horses = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Carrera $raceNumber'),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Wrap(
                spacing: 6.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: horses.map((horseNumber) {
                  return HorseOption(
                    number: horseNumber,
                    selected:
                        selectedHorse > 0 ? horseNumber == selectedHorse : true,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
