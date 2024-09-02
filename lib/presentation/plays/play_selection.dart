import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:flutter/material.dart';

class PlaySelection extends StatefulWidget {
  const PlaySelection({Key? key, required this.races}) : super(key: key);

  final List<List<int>> races;

  @override
  State<PlaySelection> createState() => _PlaySelectionState();
}

class _PlaySelectionState extends State<PlaySelection> {
  late int currentRace;
  final List<int> selectedHorses = List.empty();

  @override
  void initState() {
    currentRace = 0;

    super.initState();
  }

  void fowardRace() {
    setState(() {
      if (currentRace < 5) {
        currentRace++;
      }
    });
  }

  void backRace() {
    setState(() {
      if (currentRace > 0) {
        currentRace--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      alignment: Alignment.centerRight,
      color: AppColors.green,
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 296,
          minHeight: 196,
        ),
        child: Container(
          padding: const EdgeInsets.all(30.0),
          color: AppColors.darkGreen,
          child: Builder(
            builder: (context) {
              final isCompressedView = screenWidth <= 840;
              if (isCompressedView) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaceIndicator(raceNumber: currentRace),
                    const SizedBox(height: 16),
                    Center(
                      child: Race(
                        raceNumber: 1,
                        horses: widget.races[currentRace],
                      ),
                    ),
                    const SizedBox(height: 16),
                    RacePaginator(
                      raceNumber: currentRace,
                      onNext: fowardRace,
                      onBack: backRace,
                    ),
                  ],
                );
              } else {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RaceIndicator(raceNumber: currentRace),
                    Flexible(
                      child: Race(
                        raceNumber: 1,
                        horses: widget.races[currentRace],
                      ),
                    ),
                    const SizedBox(width: 20),
                    RacePaginator(
                      raceNumber: currentRace,
                      onNext: fowardRace,
                      onBack: backRace,
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class RaceIndicator extends StatelessWidget {
  const RaceIndicator({Key? key, required this.raceNumber}) : super(key: key);

  final int raceNumber;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= 840;
    return Builder(builder: (context) {
      if (isCompressedView) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Carrera ${raceNumber + 1}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  '${raceNumber + 1} de 6',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona un caballo para esta carrera',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        );
      } else {
        return SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${raceNumber + 1} de 6',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Carrera ${raceNumber + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Selecciona un caballo para esta carrera',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}

class RacePaginator extends StatelessWidget {
  const RacePaginator({
    Key? key,
    required this.raceNumber,
    required this.onNext,
    required this.onBack,
  }) : super(key: key);

  final int raceNumber;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= 840;
    return Builder(builder: (context) {
      if (!isCompressedView) {
        return Row(
          children: [
            const SizedBox(width: 40),
            Column(
              children: [
                ElevatedButton(
                  onPressed: raceNumber > 0 ? onBack : null,
                  child: const Text('Carrera Anterior'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: raceNumber < 6 ? onNext : null,
                  child:
                      Text(raceNumber == 5 ? 'Finalizar' : 'Siguiente Carrera'),
                ),
              ],
            ),
          ],
        );
      } else {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: raceNumber > 0 ? onBack : null,
              child: const Text(
                '<<  Atras',
                textAlign: TextAlign.center,
              ),
            ),
            // screenWidth > 400
            //     ? ElevatedButton(
            //         onPressed: () {},
            //         child: Text('Carrera Anterior'),
            //       )
            //     : TextButton(onPressed: () {}, child: Text('<<')),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: raceNumber < 6 ? onNext : null,
              child: Text(
                raceNumber == 5 ? 'Finalizar' : 'Siguiente >>',
                textAlign: TextAlign.center,
              ),
            ),
            // screenWidth > 400
            //     ? ElevatedButton(
            //         onPressed: () {},
            //         child: Text('Siguient Carrera'),
            //       )
            //     : TextButton(onPressed: () {}, child: Text('>>')),
          ],
        );
      }
    });
  }
}
