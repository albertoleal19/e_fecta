import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/admin/admin_screen.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
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
          child: Builder(builder: (context) {
            return Column(
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
                          current is PlaysNotAvailable,
                      builder: (context, state) {
                        final playSelectionOpened =
                            state is TogglePlaysSelectionState && state.opened;
                        return Column(
                          children: [
                            if (state is PlaysNotAvailable) ...{
                              Padding(
                                padding: const EdgeInsets.all(20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.errorRed,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 10),
                                  child: const Text(
                                    '*** No hay jornadas disponibles por los momentos ***',
                                  ),
                                ),
                              ),
                            },
                            if (state is! PlaysNotAvailable) ...{
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
                            },
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
  }
}
