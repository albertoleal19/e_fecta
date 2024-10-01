import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:flutter/material.dart';

class PlaySelection extends StatefulWidget {
  const PlaySelection({Key? key, required this.races}) : super(key: key);

  final List<List<int>> races;

  @override
  State<PlaySelection> createState() => _PlaySelectionState();
}

class _PlaySelectionState extends State<PlaySelection> {
  late int currentStep;
  final List<int> selectedHorses = List.empty();

  bool showSummary = false;

  @override
  void initState() {
    currentStep = 0;

    super.initState();
  }

  void fowardRace() {
    setState(() {
      currentStep++;
    });
  }

  void backRace() {
    setState(() {
      if (currentStep > 0) {
        currentStep--;
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
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 296,
          minHeight: 196,
        ),
        padding: const EdgeInsets.all(30.0),
        color: AppColors.darkGreen,
        child: Builder(
          builder: (context) {
            final isCompressedView = screenWidth <= WindowSizeContants.medium;
            if (isCompressedView) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RaceIndicator(raceNumber: currentStep),
                  if (currentStep < 6) ...[
                    const SizedBox(height: 16),
                    Center(
                      child: Race(
                        raceNumber: currentStep,
                        horses: widget.races[currentStep],
                        multiselection: true,
                      ),
                    ),
                  ],
                  if (currentStep == 6) ...[
                    const _SummaryList(),
                  ],
                  const SizedBox(height: 16),
                  RacePaginator(
                    raceNumber: currentStep,
                    onNext: fowardRace,
                    onBack: backRace,
                    onFinish: fowardRace,
                  ),
                ],
              );
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RaceIndicator(raceNumber: currentStep),
                  if (currentStep < 6) ...[
                    Flexible(
                      child: Race(
                        raceNumber: currentStep,
                        horses: widget.races[currentStep],
                        multiselection: true,
                      ),
                    ),
                  ],
                  if (currentStep == 6) ...[
                    const Flexible(child: _SummaryList()),
                  ],
                  const SizedBox(width: 20),
                  RacePaginator(
                    raceNumber: currentStep,
                    onNext: fowardRace,
                    onBack: backRace,
                    onFinish: fowardRace,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class RaceIndicator extends StatelessWidget {
  const RaceIndicator({Key? key, required this.raceNumber, this.tokens = 0})
      : super(key: key);

  final int raceNumber;
  final int tokens;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.medium;
    return Builder(builder: (context) {
      if (isCompressedView) {
        if (raceNumber < 6) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Carrera ${raceNumber + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Selecciona un caballo para esta carrera',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${raceNumber + 1} de 6',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '$tokens Tokens',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const _SummaryInfo(
            totalTickets: 10,
            totalTokens: 20,
          );
        }
      } else {
        if (raceNumber < 6) {
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
        } else {
          return const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: SizedBox(
              width: 180,
              child: _SummaryInfo(
                totalTickets: 10,
                totalTokens: 20,
              ),
            ),
          );
        }
      }
    });
  }
}

class _SummaryInfo extends StatelessWidget {
  const _SummaryInfo({
    Key? key,
    required this.totalTickets,
    this.totalTokens = 0,
  }) : super(key: key);

  final int totalTickets;
  final int totalTokens;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.medium;

    if (!isCompressedView) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Total Tickets',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalTickets',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Total Tokens',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$totalTokens',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    } else {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: WindowSizeContants.medium),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalTickets Tickets',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '$totalTokens Tokens',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }
}

class RacePaginator extends StatelessWidget {
  const RacePaginator({
    Key? key,
    required this.raceNumber,
    required this.onNext,
    required this.onBack,
    required this.onFinish,
  }) : super(key: key);

  final int raceNumber;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.medium;
    return Builder(builder: (context) {
      if (!isCompressedView) {
        return Row(
          children: [
            const SizedBox(width: 20),
            Column(
              children: [
                ElevatedButton(
                  onPressed: raceNumber > 0 ? onBack : null,
                  child: raceNumber < 6
                      ? const Text('Carrera Anterior')
                      : const Text('Modificar'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: raceNumber < 5
                      ? onNext
                      : raceNumber == 5
                          ? onFinish
                          : onFinish,

                  ///This should be on confirm bet
                  child: Text(raceNumber < 5
                      ? 'Siguiente Carrera'
                      : raceNumber == 5
                          ? 'Ver Resumen'
                          : 'Confirmar'),
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
              child: Text(
                raceNumber < 6 ? '<<  Atras' : 'Modificar',
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
              onPressed: raceNumber < 5
                  ? onNext
                  : raceNumber == 5
                      ? onFinish
                      : onFinish,

              ///This should be on confirm bet
              child: Text(
                raceNumber < 5
                    ? 'Siguiente >>'
                    : raceNumber == 5
                        ? 'Ver Resumen'
                        : 'Confirmar',
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

class _SummaryList extends StatelessWidget {
  const _SummaryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          maxHeight: 200, maxWidth: WindowSizeContants.medium),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: 50,
                child: Text('No.'),
              ),
              Expanded(child: Container()),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              physics: const ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const TicketInfo()
                  ],
                );
              },
              itemCount: 10,
              separatorBuilder: (context, index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectionSummary extends StatelessWidget {
  const SelectionSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.compact;
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxHeight: 400,
      ),
      child: Builder(
        builder: (context) {
          if (isCompressedView) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Total de Tickets 10',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Column(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TicketInfo(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 10,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Modificar'),
                    ),
                    SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: null,
                      child: Text('Confirmar'),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Total de Tickets 10',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 40),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return IntrinsicHeight(
                        child: Row(
                          children: [
                            SizedBox(
                              width: 50,
                              child: Column(
                                children: [
                                  Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            const Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TicketInfo(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: 10,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
                const SizedBox(width: 40),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: null,
                          child: Text('Modificar'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: null,
                          child: Text('Confirmar'),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            );
          }
        },
      ),
    );
  }
}
