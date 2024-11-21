import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:e_fecta/presentation/admin/admin_screen.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/common/header/cubit/header_cubit.dart';
import 'package:e_fecta/presentation/common/header/header.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:e_fecta/presentation/plays/play_selection.dart';
import 'package:e_fecta/presentation/plays/tickets_model.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: const Header(),
      endDrawer: Drawer(
        backgroundColor: AppColors.green,
        width: 300,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.darkGreen),
              child: Text('Administracion'),
            ),
            ListTile(
              title: const Text('Configurar carreras'),
              onTap: () {
                // Update the state of the app
                context.read<HeaderCubit>().displayRaceConfiguration();
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Configurar retirados'),
              selected: false,
              onTap: () {
                // Update the state of the app

                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Indicar ganadores'),
              selected: false,
              onTap: () {
                // Update the state of the app

                // Then close the drawer
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BlocBuilder<HeaderCubit, HeaderState>(
                builder: (context, headerState) {
                  if (headerState is HeaderInfoChanged &&
                      headerState.adminActive) {
                    return const AdminScreen();
                  }
                  return BlocBuilder<PlaysCubit, PlaysState>(
                    buildWhen: (previous, current) =>
                        current is TogglePlaysSelectionState ||
                        current is PlaysRacesConfigLoaded ||
                        current is PlaysNotAvailable,
                    builder: (context, state) {
                      final playSelectionOpened =
                          (state is TogglePlaysSelectionState &&
                                  state.opened) ||
                              (state is PlaysRacesConfigLoaded &&
                                  state.isPlayConfigOpened);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (!playSelectionOpened) ...[
                            Builder(
                              builder: (context) {
                                if (state is PlaysNotAvailable) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.errorRed,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 30, vertical: 10),
                                        child: const Text(
                                          '*** No hay jornadas disponibles por los momentos ***',
                                        ),
                                      ),
                                    ),
                                  );
                                } else if (state is PlaysRacesConfigLoaded ||
                                    state is TogglePlaysSelectionState) {
                                  return Center(
                                    child: Padding(
                                      padding: playSelectionOpened
                                          ? const EdgeInsets.only(top: 20)
                                          : const EdgeInsets.all(20),
                                      child: ElevatedButton(
                                        onPressed: context
                                            .read<PlaysCubit>()
                                            .togglePlaysSelections,
                                        child: Text(playSelectionOpened
                                            ? 'Cerrar'
                                            : 'Seleccionar Apuesta'),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
                          if (playSelectionOpened) ...[
                            const PlaySelection(),
                          ],
                          SizedBox(
                            height: screenHeight - kToolbarHeight,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Resultados',
                                    style: TextStyle(fontSize: 56),
                                  ),
                                ),
                                BlocBuilder<PlaysCubit, PlaysState>(
                                  buildWhen: (previous, current) =>
                                      current is PlaysTicketsDisplay,
                                  builder: (context, state) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      child: Container(
                                        color: const Color(0x36405380),
                                        height: 80,
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20.0,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'Pollas Jugadas',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            Text(
                                              '${state.ticketsCount}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 66),
                                            const SizedBox(
                                              height: 60,
                                              child: VerticalDivider(),
                                            ),
                                            const SizedBox(width: 66),
                                            SizedBox(
                                              width: 200,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Premio 1er Lugar:',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const Text(
                                                        '400 Tokens',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Premio 2do Lugar:',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const Text(
                                                        '200 Tokens',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                        'Premio 3er Lugar:',
                                                        style: TextStyle(
                                                            fontSize: 12),
                                                      ),
                                                      const Text(
                                                        '100 Tokens',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                BlocBuilder<PlaysCubit, PlaysState>(
                                  buildWhen: (previous, current) =>
                                      current is PlaysResultsRacedays,
                                  builder: (context, state) {
                                    if (state is PlaysResultsRacedays) {
                                      final racedays = state.racedays;
                                      // racedays.sort((a, b) =>
                                      //     a.closingTime.isBefore(b.closingTime)
                                      //         ? 1
                                      //         : -1);
                                      return Container(
                                        padding: const EdgeInsets.only(
                                          left: 20.0,
                                          bottom: 10,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Mostrando resultados de:',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            const SizedBox(height: 10),
                                            SizedBox(
                                              height: 30,
                                              child: ListView.separated(
                                                itemCount: racedays.length,
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const SizedBox(width: 6),
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return ChoiceChip(
                                                    onSelected: (value) => context
                                                        .read<PlaysCubit>()
                                                        .selectRacedayForResults(
                                                          index,
                                                        ),
                                                    label: Text(
                                                      '${racedays[index].closingTime.day}/${racedays[index].closingTime.month}/${racedays[index].closingTime.year}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    selected: index ==
                                                        state
                                                            .selectedRacedayIndex,
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                          ],
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                                Expanded(
                                  child: BlocBuilder<PlaysCubit, PlaysState>(
                                    buildWhen: (previous, current) =>
                                        current is PlaysTicketsDisplay,
                                    builder: (context, state) {
                                      if (state is PlaysTicketsDisplay) {
                                        return Center(
                                          child: Container(
                                              constraints: const BoxConstraints(
                                                  maxWidth: 1000),
                                              child: Column(
                                                children: [
                                                  Container(
                                                    color:
                                                        AppColors.darkerGreen,
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                            child: Container()),
                                                        Container(
                                                          alignment:
                                                              Alignment.center,
                                                          color:
                                                              AppColors.green,
                                                          width: 66,
                                                          height: 50,
                                                          child: const Text(
                                                            'Total',
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: FirestoreListView<
                                                        TicketModel>(
                                                      query: state.ticketsRef,
                                                      itemBuilder:
                                                          (context, snapshot) {
                                                        final ticket =
                                                            snapshot.data();
                                                        return ResultListItem(
                                                            ticket: ticket);
                                                      },
                                                      loadingBuilder:
                                                          (context) {
                                                        return Container(
                                                          color: AppColors
                                                              .darkerGreen,
                                                          alignment: Alignment
                                                              .centerRight,
                                                          child: const Center(
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: AppColors
                                                                  .darkBlue,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        );
                                      }
                                      return Container();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      );
                    },
                  );
                },
              ),
              // const Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text('1er Premio: 1500 und'),
              //           Text('2do Premio: 750 und'),
              //           Text('3er Premio: 250 und'),
              //         ],
              //       ),
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: const [
              //         Text('Sabado 13 Sept 2022 -- 15:35'),
              //         Text('Cierra en : 50 min'),
              //       ],
              //     ),
              //   ],
              // ),
              // Container(
              //   color: AppColors.darkBlue,
              //   height: 260,
              //   child: const Text('Footer'),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
