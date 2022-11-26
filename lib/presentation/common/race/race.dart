import 'package:flutter/material.dart';

import '../horse_option.dart';

class Race extends StatefulWidget {
  final int raceNumber;
  final int selectedHorse;
  final List<int> horses;
  final bool multiselection;

  const Race({
    Key? key,
    required this.raceNumber,
    this.selectedHorse = -1,
    this.horses = const [],
    this.multiselection = false,
  }) : super(key: key);

  @override
  State<Race> createState() => _RaceState();
}

class _RaceState extends State<Race> {
  List<int> selectedHourses = <int>[];

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Carrera ${widget.raceNumber}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6.0, // gap between adjacent chips
                    runSpacing: 4.0, // gap between lines
                    children: widget.horses.map(
                      (horseNumber) {
                        return HorseOption(
                          number: horseNumber,
                          onSelect: () {
                            setState(() {
                              if (!widget.multiselection) {
                                selectedHourses.clear();
                                selectedHourses.add(horseNumber);
                              } else if (selectedHourses
                                  .contains(horseNumber)) {
                                selectedHourses.remove(horseNumber);
                              } else {
                                selectedHourses.add(horseNumber);
                              }
                            });
                          },
                          selected: selectedHourses.contains(horseNumber),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
