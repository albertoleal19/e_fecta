import 'package:e_fecta/presentation/common/header/header.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 30, top: 30),
              child: ListView(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('1er Premio: 1500 und'),
                            Text('2do Premio: 750 und'),
                            Text('3er Premio: 250 und'),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text('Sabado 13 Sept 2022 -- 15:35'),
                          Text('Cierra en : 50 min'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Race(
                    raceNumber: 1,
                    horses: [1, 3, 5, 6, 7, 8, 9, 10, 13, 14],
                    selectedHorse: 9,
                    multiselection: true,
                  ),
                  const Race(
                    raceNumber: 2,
                    horses: [2, 4, 5, 6, 8],
                  ),
                  const Race(
                    raceNumber: 3,
                    horses: [1, 2, 3, 4, 5, 6, 8, 11, 12],
                    selectedHorse: 4,
                  ),
                  const Race(
                    raceNumber: 4,
                    horses: [1, 3, 5, 6, 7, 8, 9, 12],
                    selectedHorse: 9,
                  ),
                  const Race(
                    raceNumber: 5,
                    horses: [1, 3, 4, 5, 6, 7, 8, 9],
                  ),
                  const Race(
                    raceNumber: 6,
                    horses: [8, 9, 10, 13, 14],
                    selectedHorse: 13,
                  ),
                ],
              ),
            ),
          ),
          Container(
            //alignment: Alignment.topLeft,
            width: 200,
            color: Colors.lightGreenAccent,
            child: const Text('This is Container 2'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
