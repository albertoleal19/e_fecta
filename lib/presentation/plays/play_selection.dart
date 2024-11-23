import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaySelection extends StatefulWidget {
  const PlaySelection({Key? key}) : super(key: key);

  @override
  State<PlaySelection> createState() => _PlaySelectionState();
}

class _PlaySelectionState extends State<PlaySelection> {
  List<List<int>>? races;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaysCubit>();
    cubit.getRacedayConfig();
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.medium;
    return Container(
      alignment: isCompressedView ? Alignment.centerRight : Alignment.center,
      color: AppColors.green,
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
      child: Container(
        constraints: const BoxConstraints(
          minWidth: 296,
          minHeight: 196,
          maxWidth: 800,
        ),
        padding: const EdgeInsets.all(30.0),
        color: AppColors.darkGreen,
        child: BlocConsumer<PlaysCubit, PlaysState>(
          listener: (BuildContext context, PlaysState state) {
            if (state is PlaysRacesConfigLoaded) {
              races = state.racesOptions;
            }
          },
          buildWhen: (previous, current) =>
              current is PlaysSelectionChanged ||
              current is PlaysRacesConfigLoaded ||
              current is PlaysSummary,
          builder: (context, state) {
            if (state is PlaysSelectionChanged ||
                state is PlaysRacesConfigLoaded) {
              final selection =
                  state is PlaysChangeState ? state.selectedHourses : [];
              var tokensPerTicket = 1;
              DateTime? closingTime;

              if (state is PlaysRacesConfigLoaded) {
                tokensPerTicket = state.tokensPerTicket;
                closingTime = state.closingTime;
              } else {
                tokensPerTicket =
                    (state as PlaysSelectionChanged).tokensPerTicket;
                closingTime = (state).closingTime;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                    child: Expanded(
                      child: Row(
                        mainAxisAlignment: isCompressedView
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Text(
                            'Programada para: ${closingTime.year}/${closingTime.month}/${closingTime.day}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const VerticalDivider(),
                          Text(
                            '$tokensPerTicket Tokens x ticket',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Selecciona tus opciones por carrera.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...List<Widget>.generate(
                    6,
                    (index) {
                      final List<int> options = List.from(races?[index] ?? []);
                      options.sort((a, b) => a.compareTo(b));

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Carrera ${index + 1}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Race(
                            raceNumber: index,
                            horses: options,
                            selectionConfig: SelectionConfig.multi,
                            selectedHorses:
                                selection.isNotEmpty ? selection[index] : [],
                            onSelectionChanged: (List<int> selected) {
                              cubit.setSelection(
                                optionSelected: selected,
                                race: index,
                              );
                            },
                          ),
                          if (index < 5) ...[
                            const SizedBox(height: 12),
                            const Divider(),
                          ]
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        if (state is PlaysChangeState &&
                            state.exceededTokens) ...[
                          const Text(
                            'No puedes seleccionar mas opciones, no tienes tokens suficientes.',
                            style: TextStyle(
                                color: AppColors.errorYellow, fontSize: 16),
                          ),
                          const SizedBox(height: 20),
                        ],
                        SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.ticketsCount} Tickets',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const VerticalDivider(),
                              Text(
                                '${state.tokensCount} Tokens',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      cubit.togglePlaysSelections(),
                                  child: const Text('Cancelar'),
                                ),
                                const VerticalDivider(),
                                ElevatedButton(
                                  onPressed: state is PlaysChangeState
                                      ? (state.isValidPlay &&
                                              !state.exceededTokens
                                          ? cubit.calcultaSummary
                                          : null)
                                      : null,
                                  child: const Text('Ver Resumen'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is PlaysSummary) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Resumen',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const _SummaryList(),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${state.ticketsCount} Tickets',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const VerticalDivider(),
                              Text(
                                '${state.tokensCount} Tokens',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: cubit.modifySelection,
                              child: const Text('Modificar'),
                            ),
                            ElevatedButton(
                              onPressed: cubit.sealTicket,
                              child: const Text('Sellar Ticket'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class _SummaryList extends StatelessWidget {
  const _SummaryList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaysCubit, PlaysState>(
      buildWhen: (previous, current) => current is PlaysSummary,
      builder: (context, state) {
        if (state is PlaysSummary) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: state.ticketsCount < 4 ? 200 : 400,
              maxWidth: WindowSizeContants.compact,
            ),
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
                    shrinkWrap: true,
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
                          Expanded(
                              child: TicketInfo(
                            options: state.tickets[index],
                            showPtsRow: false,
                          )),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      );
                    },
                    itemCount: state.tickets.length,
                    separatorBuilder: (context, index) => const Divider(),
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
