import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/domain/entities/raceday.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/common/horse_option.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RaceListItem extends StatelessWidget {
  const RaceListItem({Key? key, required this.raceday}) : super(key: key);

  final Raceday raceday;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    return Container(
      color: AppColors.darkerGreen,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Builder(builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RacedayGeneralInfo(
                racedayId: raceday.id,
                closingTime: raceday.closingTime,
                tokensPerTicket: raceday.tokensPerTicket,
                isOpen: raceday.isOpen,
              ),
              const SizedBox(height: 20),
              RacesConfig(
                options: raceday.racesOptions,
                // winners: raceday.winners,
              ),
            ],
          );
        }),
      ),
    );
  }
}

class RacedayGeneralInfo extends StatelessWidget {
  const RacedayGeneralInfo({
    Key? key,
    required this.closingTime,
    required this.tokensPerTicket,
    required this.racedayId,
    this.isOpen = false,
  }) : super(key: key);
  final DateTime closingTime;
  final String racedayId;
  final int tokensPerTicket;
  final bool isOpen;

  String get closingTimeString =>
      '${closingTime.year}/${closingTime.month.toString().padLeft(2, '0')}/${closingTime.day.toString().padLeft(2, '0')} ${closingTime.hour.toString().padLeft(2, '0')}:${closingTime.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    final cubit = context.read<AdminCubit>();
    if (isCompressedScreen) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Text(closingTimeString),
                Expanded(child: Container()),
                IconButton(
                  onPressed: () => {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              '''${isOpen ? 'Cerrar' : 'Abrir'} Polla ($racedayId)'''),
                          content: Text(
                            isOpen
                                ? 'Al cerrar la polla, no se permitira crear mas tickets'
                                : 'Al  abrir la polla,  se permitirá la creación de tickets.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                textStyle:
                                    Theme.of(context).textTheme.labelLarge,
                              ),
                              child: const Text('Corfirmar'),
                              onPressed: () async {
                                // perform action
                                await cubit.changeRacedayStatus(
                                  !isOpen,
                                  racedayId,
                                );
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  },
                  icon: Icon(
                    isOpen ? FontAwesomeIcons.lock : FontAwesomeIcons.unlock,
                  ),
                ),
                const VerticalDivider(),
                IconButton(
                  onPressed: () => cubit.showEditTicketSection(racedayId),
                  icon: const Icon(FontAwesomeIcons.penToSquare),
                ),
                const VerticalDivider(),
                IconButton(
                  onPressed: () => {},
                  icon: const Icon(FontAwesomeIcons.medal),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text('$tokensPerTicket Tokens x Ticket'),
        ],
      );
    }
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Text(closingTimeString),
          const VerticalDivider(),
          Text('$tokensPerTicket Tokens x Ticket'),
          Expanded(child: Container()),
          TextButton(
            onPressed: () => {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                        '''${isOpen ? 'Cerrar' : 'Abrir'} Polla ($racedayId)'''),
                    content: Text(
                      isOpen
                          ? 'Al cerrar la polla, no se permitira crear mas tickets'
                          : 'Al  abrir la polla,  se permitirá la creación de tickets.',
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          textStyle: Theme.of(context).textTheme.labelLarge,
                        ),
                        child: const Text('Corfirmar'),
                        onPressed: () async {
                          // perform action
                          await cubit.changeRacedayStatus(
                            !isOpen,
                            racedayId,
                          );
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              ),
            },
            child: Text(isOpen ? 'Cerrar' : 'Abrir'),
          ),
          const VerticalDivider(),
          TextButton(
            onPressed: () => cubit.showEditTicketSection(racedayId),
            child: const Text('Editar'),
          ),
          const VerticalDivider(),
          TextButton(
            onPressed: () => {},
            child: const Text('Indicar Ganadores'),
          ),
        ],
      ),
    );
  }
}

class RacesConfig extends StatelessWidget {
  const RacesConfig({
    Key? key,
    this.maxWidth = double.maxFinite,
    this.padding,
    this.options = const [[], [], [], [], [], []],
    this.winners,
  }) : super(key: key);

  final double maxWidth;
  final EdgeInsets? padding;
  final List<List<int>> options;
  final List<List<int>?>? winners;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ...List<Widget>.generate(
              options.length,
              (index) {
                if (isCompressedScreen) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Carrera ${index + 1}',
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Race(
                        raceNumber: index,
                        horses: options[index],
                        selectionConfig: SelectionConfig.none,
                      ),
                      const SizedBox(height: 6),
                      Winners(
                        places: winners?[index],
                      ),
                      const SizedBox(height: 6),
                    ],
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Carrera ${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Race(
                              raceNumber: index,
                              horses: options[index],
                              selectionConfig: SelectionConfig.none,
                            ),
                            const SizedBox(height: 6),
                          ],
                        ),
                      ),
                      Winners(
                        places: winners?[index],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Winners extends StatelessWidget {
  const Winners({Key? key, this.places}) : super(key: key);

  final List<int>? places;

  @override
  Widget build(BuildContext context) {
    if (places != null && places!.isNotEmpty) {
      final double width = MediaQuery.sizeOf(context).width;
      final isCompressedScreen = width < WindowSizeContants.compact;
      if (isCompressedScreen) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (places != null && places!.isNotEmpty) ...{
              const Text(
                'Ganadores ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),

              // ignore: equal_elements_in_set
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '1ro:',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      HorseOption(number: places![0], selectable: false),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '2do:',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 10),
                      HorseOption(number: places![1], selectable: false),
                    ],
                  ),
                  if (places!.length == 3) ...{
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '3ro:',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),
                        HorseOption(number: places![2], selectable: false),
                      ],
                    ),
                  },
                ],
              ),
            },
          ],
        );
      } else {
        return SizedBox(
          width: 130,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ganadores ',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                    child: Text(
                      '1ro:',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  HorseOption(number: places![0], selectable: false),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const SizedBox(
                    width: 30,
                    child: Text(
                      '2do:',
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  HorseOption(number: places![1], selectable: false),
                ],
              ),
              // ignore: equal_elements_in_set
              const SizedBox(height: 8),
              if (places!.length == 3) ...{
                Row(
                  children: [
                    const SizedBox(
                      width: 30,
                      child: Text(
                        '3ro:',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    HorseOption(number: places![2], selectable: false),
                  ],
                ),
              },
            ],
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }
}
