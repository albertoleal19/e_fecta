import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/admin/admin_screen.dart';
import 'package:e_fecta/presentation/common/header/cubit/header_cubit.dart';
import 'package:e_fecta/presentation/common/header/header.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:e_fecta/presentation/plays/play_selection.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      endDrawer: Drawer(
        backgroundColor: AppColors.green,
        width: 300,
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppColors.darkGreen),
              child: Text('Admin'),
            ),
            ListTile(
              title: const Text('Configurar carreras'),
              onTap: () {
                // Update the state of the app
                context.read<HeaderCubit>().displayRaceConfiguraiton();
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
          child: Builder(builder: (context) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlocBuilder<HeaderCubit, HeaderState>(
                  builder: (context, headerState) {
                    if (headerState is HeaderTrackChanged &&
                        headerState.selectedAdminConfig > -1) {
                      return const AdminScreen();
                    }
                    return BlocBuilder<PlaysCubit, PlaysState>(
                      buildWhen: (previous, current) =>
                          current is TogglePlaysSelectionState,
                      builder: (context, state) {
                        final playSelectionOpened =
                            state is TogglePlaysSelectionState && state.opened;
                        return Column(
                          children: [
                            Padding(
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
                            if (playSelectionOpened) ...[
                              const PlaySelection(),
                            ],
                            Container(
                              color: AppColors.darkBlue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.0,
                                      left: 20.0,
                                      bottom: 20.0,
                                    ),
                                    child: Text(
                                      'Resultados',
                                      style: TextStyle(fontSize: 64),
                                    ),
                                  ),
                                  Center(
                                    child: Container(
                                      color: AppColors.darkBlue,
                                      constraints:
                                          const BoxConstraints(maxWidth: 1000),
                                      height: 730,
                                      child: Column(
                                        children: [
                                          Container(
                                            color: AppColors.darkerGreen,
                                            alignment: Alignment.centerRight,
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(child: Container()),
                                                Container(
                                                  alignment: Alignment.center,
                                                  color: AppColors.green,
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
                                            child: ListView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                return const ResultListItem();
                                              },
                                              itemCount: 20,
                                            ),
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
                Container(
                  color: AppColors.darkBlue,
                  height: 260,
                  child: const Text('Footer'),
                ),
              ],
            );
          }),
        ),
      ),
    );
    // return BlocProvider(
    //   create: (context) => PlaysCubit(),
    //   child: BlocBuilder<PlaysCubit, PlaysState>(
    //     buildWhen: (previous, current) => current is TogglePlaysSelectionState,
    //     builder: (context, state) {
    //       final playSelectionOpened =
    //           state is TogglePlaysSelectionState && state.opened;
    //       return Scaffold(
    //         appBar: const Header(),
    //         body: SafeArea(
    //           child: SingleChildScrollView(
    //             child: Column(
    //               children: [
    //                 Padding(
    //                   padding: playSelectionOpened
    //                       ? const EdgeInsets.only(top: 20)
    //                       : const EdgeInsets.all(20),
    //                   child: ElevatedButton(
    //                     onPressed:
    //                         context.read<PlaysCubit>().togglePlaysSelections,
    //                     child: Text(playSelectionOpened
    //                         ? 'Cerrar'
    //                         : 'Seleccionar Apuesta'),
    //                   ),
    //                 ),
    //                 if (playSelectionOpened) ...[
    //                   const PlaySelection(),
    //                 ],
    //                 // Center(
    //                 //   child: ElevatedButton(
    //                 //     onPressed: () {
    //                 //       showModalBottomSheet<void>(
    //                 //         context: context,
    //                 //         builder: (BuildContext context) {
    //                 //           return SizedBox(
    //                 //             height: 200,
    //                 //             child: Center(
    //                 //               child: Column(
    //                 //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 //                 mainAxisSize: MainAxisSize.min,
    //                 //                 children: <Widget>[
    //                 //                   const Text('Modal BottomSheet'),
    //                 //                   ElevatedButton(
    //                 //                     child: const Text('Close BottomSheet'),
    //                 //                     onPressed: () => Navigator.pop(context),
    //                 //                   ),
    //                 //                 ],
    //                 //               ),
    //                 //             ),
    //                 //           );
    //                 //         },
    //                 //       );
    //                 //     },
    //                 //     child: const Text('Hacer la apuesta'),
    //                 //   ),
    //                 // ),
    //                 Container(
    //                   color: AppColors.darkBlue,
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       const Padding(
    //                         padding: EdgeInsets.only(
    //                           top: 20.0,
    //                           left: 20.0,
    //                           bottom: 20.0,
    //                         ),
    //                         child: Text(
    //                           'Resultados',
    //                           style: TextStyle(fontSize: 64),
    //                         ),
    //                       ),
    //                       Center(
    //                         child: Container(
    //                           color: AppColors.darkBlue,
    //                           constraints: const BoxConstraints(maxWidth: 1000),
    //                           height: 730,
    //                           child: Column(
    //                             children: [
    //                               Container(
    //                                 color: AppColors.darkerGreen,
    //                                 alignment: Alignment.centerRight,
    //                                 child: Row(
    //                                   mainAxisSize: MainAxisSize.max,
    //                                   children: [
    //                                     Expanded(child: Container()),
    //                                     Container(
    //                                       alignment: Alignment.center,
    //                                       color: AppColors.green,
    //                                       width: 66,
    //                                       height: 50,
    //                                       child: const Text(
    //                                         'Total',
    //                                       ),
    //                                     )
    //                                   ],
    //                                 ),
    //                               ),
    //                               Expanded(
    //                                 child: ListView.builder(
    //                                   physics: const ClampingScrollPhysics(),
    //                                   itemBuilder: (context, index) {
    //                                     return const ResultListItem();
    //                                   },
    //                                   itemCount: 20,
    //                                 ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const Row(
    //                   crossAxisAlignment: CrossAxisAlignment.start,
    //                   children: [
    //                     Expanded(
    //                       child: Column(
    //                         crossAxisAlignment: CrossAxisAlignment.start,
    //                         children: [
    //                           Text('1er Premio: 1500 und'),
    //                           Text('2do Premio: 750 und'),
    //                           Text('3er Premio: 250 und'),
    //                         ],
    //                       ),
    //                     ),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.end,
    //                       children: const [
    //                         Text('Sabado 13 Sept 2022 -- 15:35'),
    //                         Text('Cierra en : 50 min'),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //                 Container(
    //                   color: AppColors.darkBlue,
    //                   height: 260,
    //                   child: const Text('Footer'),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //         // floatingActionButton: FloatingActionButton(
    //         //   onPressed: () => {},
    //         //   tooltip: 'Increment',
    //         //   child: const Icon(Icons.add),
    //         // ),
    //       );
    //     },
    //   ),
    // );
  }
}

// Container(
//   width: width,
//   color: AppColors.green,
//   alignment: Alignment.centerRight,
//   child: const Padding(
//     padding: EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
//     child: Race(
//       raceNumber: 1,
//       horses: [1, 3, 5, 6, 7, 8, 9, 10, 13, 14],
//       selectedHorse: 9,
//       multiselection: true,
//     ),
//   ),
// ),
// const Race(
//   raceNumber: 2,
//   horses: [2, 4, 5, 6, 8],
// ),
// const Race(
//   raceNumber: 3,
//   horses: [1, 2, 3, 4, 5, 6, 8, 11, 12],
//   selectedHorse: 4,
// ),
// const Race(
//   raceNumber: 4,
//   horses: [1, 3, 5, 6, 7, 8, 9, 12],
//   selectedHorse: 9,
// ),
// const Race(
//   raceNumber: 5,
//   horses: [1, 3, 4, 5, 6, 7, 8, 9],
// ),
// const Race(
//   raceNumber: 6,
//   horses: [8, 9, 10, 13, 14],
//   selectedHorse: 13,
// ),
