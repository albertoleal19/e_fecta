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

  @override
  void initState() {
    super.initState();
  }

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
            // SegmentedButton<int>(
            //   segments: const <ButtonSegment<int>>[
            //     ButtonSegment<int>(
            //         value: 1,
            //         label: Text('Day'),
            //         icon: Icon(Icons.calendar_view_day)),
            //     ButtonSegment<int>(
            //         value: 2,
            //         label: Text('Week'),
            //         icon: Icon(Icons.calendar_view_week)),
            //     ButtonSegment<int>(
            //         value: 3,
            //         label: Text('Month'),
            //         icon: Icon(Icons.calendar_view_month)),
            //     ButtonSegment<int>(
            //         value: 4,
            //         label: Text('Year'),
            //         icon: Icon(Icons.calendar_today)),
            //   ],
            //   selected: <int>{1},
            //   onSelectionChanged: (Set<int> newSelection) {
            //     setState(() {
            //       // By default there is only a single segment that can be
            //       // selected at one time, so its value is always the first
            //       // item in the selected set.
            //       // calendarView = newSelection.first;
            //     });
            //   },
            // ),
            SegmentedButton<int>(
              segments: <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 1,
                  label: const Text('1ra'),
                  enabled: _shouldBeEnabled(1),
                  // icon: Icon(Icons.calendar_view_day),
                ),
                ButtonSegment<int>(
                  value: 2,
                  label: const Text('2da'),
                  enabled: _shouldBeEnabled(2),
                  // icon: Icon(Icons.calendar_view_week),
                ),
                ButtonSegment<int>(
                  value: 3,
                  label: const Text('3ra'),
                  enabled: _shouldBeEnabled(3),
                  // icon: Icon(Icons.calendar_view_month),
                ),
                ButtonSegment<int>(
                  value: 4,
                  label: const Text('4ta'),
                  enabled: _shouldBeEnabled(4),
                  // icon: Icon(Icons.calendar_today),
                ),
                ButtonSegment<int>(
                  value: 5,
                  label: const Text('5ta'),
                  enabled: _shouldBeEnabled(5),
                  // icon: Icon(Icons.calendar_today),
                ),
                ButtonSegment<int>(
                  value: 6,
                  label: const Text('6ta'),
                  enabled: _shouldBeEnabled(6),
                  // icon: Icon(Icons.calendar_today),
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
          ],
        ),
      ),
    );
  }
}
