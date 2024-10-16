import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaySelection extends StatelessWidget {
  const PlaySelection({Key? key, required this.races}) : super(key: key);

  final List<List<int>> races;

  // late PlaysCubit? cubit;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlaysCubit>();
    return Container(
      alignment: Alignment.centerRight,
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
        child: BlocBuilder<PlaysCubit, PlaysState>(
          buildWhen: (previous, current) =>
              current is PlaysInitial ||
              current is PlaysSelectionChanged ||
              current is PlaysSummary,
          builder: (context, state) {
            if (state is PlaysInitial || state is PlaysSelectionChanged) {
              final currentState = state as PlaysChangeState;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecciona tus opciones por carrera.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  ...List<Widget>.generate(
                    6,
                    (index) {
                      final List<int> options = List.from(races[index]);
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
                            multiselection: true,
                            selectedHorses:
                                currentState.selectedHourses.isNotEmpty
                                    ? currentState.selectedHourses[index]
                                    : [],
                            onSelectionChanged: (List<int> selected) {
                              cubit?.setSelection(
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
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed:
                              state.isValidPlay ? cubit.calcultaSummary : null,
                          child: const Text('Ver Resumen'),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (state is PlaysSummary) {
              // return ListView.separated(

              //   physics: const ClampingScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return Row(
              //       mainAxisSize: MainAxisSize.min,
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(
              //           width: 50,
              //           child: Text(
              //             '${index + 1}',
              //             style: const TextStyle(
              //               fontSize: 14,
              //             ),
              //           ),
              //         ),
              //         TicketInfo(options: state.tickets[index])
              //       ],
              //     );
              //   },
              //   itemCount: state.tickets.length,
              //   separatorBuilder: (context, index) => const Divider(),
              // );
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
            // child: ListView.separated(
            //   scrollDirection: Axis.vertical,
            //   shrinkWrap: true,
            //   physics: const ClampingScrollPhysics(),
            //   itemBuilder: (context, index) {
            //     return Row(
            //       mainAxisSize: MainAxisSize.min,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(
            //           width: 50,
            //           child: Text(
            //             '${index + 1}',
            //             style: const TextStyle(
            //               fontSize: 14,
            //             ),
            //           ),
            //         ),
            //         TicketInfo(options: state.tickets[index])
            //       ],
            //     );
            //   },
            //   itemCount: state.tickets.length,
            //   separatorBuilder: (context, index) => const Divider(),
            // ),
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
                          TicketInfo(options: state.tickets[index])
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

// class SelectionSummary extends StatelessWidget {
//   const SelectionSummary({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     final isCompressedView = screenWidth <= WindowSizeContants.compact;
//     return ConstrainedBox(
//       constraints: const BoxConstraints(
//         maxHeight: 400,
//       ),
//       child: Builder(
//         builder: (context) {
//           if (isCompressedView) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Resumen',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const Text(
//                   'Total de Tickets 10',
//                   style: TextStyle(
//                     fontSize: 14,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Expanded(
//                   child: ListView.separated(
//                     physics: const ClampingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return IntrinsicHeight(
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 30,
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     '${index + 1}',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Container(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 10),
//                             const Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TicketInfo(),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     itemCount: 10,
//                     separatorBuilder: (context, index) => const Divider(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: null,
//                       child: Text('Modificar'),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: null,
//                       child: Text('Confirmar'),
//                     ),
//                   ],
//                 ),
//               ],
//             );
//           } else {
//             return Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Resumen',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       'Total de Tickets 10',
//                       style: TextStyle(
//                         fontSize: 14,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(width: 40),
//                 ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: ListView.separated(
//                     physics: const ClampingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return IntrinsicHeight(
//                         child: Row(
//                           children: [
//                             SizedBox(
//                               width: 50,
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     '${index + 1}',
//                                     style: const TextStyle(
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   Expanded(
//                                     child: Container(),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             const Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 TicketInfo(),
//                               ],
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                     itemCount: 10,
//                     separatorBuilder: (context, index) => const Divider(),
//                   ),
//                 ),
//                 const SizedBox(width: 40),
//                 const Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Column(
//                       children: [
//                         ElevatedButton(
//                           onPressed: null,
//                           child: Text('Modificar'),
//                         ),
//                         SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: null,
//                           child: Text('Confirmar'),
//                         ),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
