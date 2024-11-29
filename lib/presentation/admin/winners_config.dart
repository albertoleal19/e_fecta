import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WinnersConfig extends StatefulWidget {
  const WinnersConfig({
    Key? key,
    required this.raceOptions,
    required this.raceNumber,
    this.prizePlaces = 3,
    this.onSetWinners,
    this.onCancel,
  }) : super(key: key);

  final List<int> raceOptions;
  final int raceNumber;
  final int prizePlaces;
  final Function(List<int> winners)? onSetWinners;
  final Function()? onCancel;

  @override
  State<WinnersConfig> createState() => _WinnersConfigState();
}

class _WinnersConfigState extends State<WinnersConfig> {
  int firstPlace = -1;
  int secondPlace = -1;
  int thirdPlace = -1;

  bool _shouldBeEnabled(int race) {
    return race >= widget.raceNumber;
  }

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<int>(
              segments: <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 1,
                  label: const Text('1ra'),
                  enabled: _shouldBeEnabled(1),
                ),
                ButtonSegment<int>(
                  value: 2,
                  label: const Text('2da'),
                  enabled: _shouldBeEnabled(2),
                ),
                ButtonSegment<int>(
                  value: 3,
                  label: const Text('3ra'),
                  enabled: _shouldBeEnabled(3),
                ),
                ButtonSegment<int>(
                  value: 4,
                  label: const Text('4ta'),
                  enabled: _shouldBeEnabled(4),
                ),
                ButtonSegment<int>(
                  value: 5,
                  label: const Text('5ta'),
                  enabled: _shouldBeEnabled(5),
                ),
                ButtonSegment<int>(
                  value: 6,
                  label: const Text('6ta'),
                  enabled: _shouldBeEnabled(6),
                ),
              ],
              selected: <int>{widget.raceNumber},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  // By default there is only a single segment that can be
                  // selected at one time, so its value is always the first
                  // item in the selected set.
                  // calendarView = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text('1er Lugar', style: TextStyle(fontSize: 14)),
            const SizedBox(height: 6),
            Race(
              raceNumber: 0,
              compressed: true,
              selectionConfig: SelectionConfig.single,
              horses: widget.raceOptions,
              disabledHorses: [thirdPlace, secondPlace],
              onSelectionChanged: (p0) {
                setState(() {
                  firstPlace = p0.first;
                });
              },
            ),
            const SizedBox(height: 10),
            if (widget.prizePlaces > 1) ...{
              const Text('2do Lugar', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Race(
                raceNumber: 0,
                compressed: true,
                selectionConfig: SelectionConfig.single,
                disabledHorses: [firstPlace, thirdPlace],
                horses: widget.raceOptions,
                onSelectionChanged: (p0) {
                  setState(() {
                    secondPlace = p0.first;
                  });
                },
              ),
              const SizedBox(height: 10),
            },
            if (widget.prizePlaces > 2) ...{
              const Text('3er Lugar', style: TextStyle(fontSize: 14)),
              const SizedBox(height: 6),
              Race(
                raceNumber: 0,
                compressed: true,
                disabledHorses: [firstPlace, secondPlace],
                selectionConfig: SelectionConfig.single,
                horses: widget.raceOptions,
                onSelectionChanged: (p0) {
                  setState(() {
                    thirdPlace = p0.first;
                  });
                },
              ),
            },
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
                          context.read<AdminCubit>().closeAdminActionSection(),
                      child: const Text('Cancelar'),
                    ),
                    const VerticalDivider(),
                    ElevatedButton(
                      onPressed: () => {
                        if (widget.onSetWinners != null)
                          {
                            widget.onSetWinners!
                                .call([firstPlace, secondPlace, thirdPlace])
                          }
                      },
                      child: const Text('Aceptar'),
                    ),
                  ],
                ),
              ),
            ),
            BlocBuilder<AdminCubit, AdminState>(
              buildWhen: (previous, current) =>
                  current is AdminSetWinnersSectionShownState,
              builder: (context, state) {
                if ((state as AdminSetWinnersSectionShownState).isLoading) {
                  return const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                    child: LinearProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
