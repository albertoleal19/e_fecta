import 'package:flutter/material.dart';

import '../horse_option.dart';

enum SelectionConfig { single, multi, none }

class Race extends StatefulWidget {
  final int raceNumber;
  final List<int>? selectedHorses;
  final List<int> horses;
  final SelectionConfig selectionConfig;
  final bool compressed;
  final Function(List<int>)? onSelectionChanged;

  const Race({
    Key? key,
    required this.raceNumber,
    this.selectedHorses,
    this.horses = const [],
    this.selectionConfig = SelectionConfig.single,
    this.compressed = true,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  State<Race> createState() => _RaceState();
}

class _RaceState extends State<Race> {
  late List<int> selectedHourses;

  @override
  void initState() {
    selectedHourses = widget.selectedHorses ?? <int>[];
    super.initState();
  }

  // @override
  // void didUpdateWidget(covariant Race oldWidget) {
  //   selectedHourses = widget.selectedHorses ?? <int>[];
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: widget.compressed ? 12.0 : 20, // gap between adjacent chips
      runSpacing: 14.0, // gap between lines

      children: widget.horses.map(
        (horseNumber) {
          return HorseOption(
            selectable: widget.selectionConfig != SelectionConfig.none,
            number: horseNumber,
            onSelect: () {
              setState(() {
                if (widget.selectionConfig != SelectionConfig.none) {
                  if (widget.selectionConfig == SelectionConfig.single) {
                    selectedHourses.clear();
                    selectedHourses.add(horseNumber);
                  } else if (selectedHourses.contains(horseNumber)) {
                    selectedHourses.remove(horseNumber);
                  } else {
                    selectedHourses.add(horseNumber);
                  }
                  widget.onSelectionChanged?.call(selectedHourses);
                }
              });
            },
            selected: selectedHourses.contains(horseNumber),
          );
        },
      ).toList(),
    );
  }

  //@override
  // Widget build(BuildContext context) {
  //   // double height = MediaQuery.of(context).size.height;
  //   double width = MediaQuery.sizeOf(context).width;
  //   print('Width: $width');
  //   return Container(
  //     color: AppColors.darkGreen,
  //     child: Padding(
  //       padding: const EdgeInsets.all(30.0),
  //       child: Builder(builder: (context) {
  //         if (width >= 790) {
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 width: 200,
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       '${widget.raceNumber} de 6',
  //                       style: const TextStyle(
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Text(
  //                       'Carrera ${widget.raceNumber}',
  //                       style: const TextStyle(
  //                         fontSize: 16,
  //                         fontWeight: FontWeight.w700,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     const Text(
  //                       'Selecciona un caballo para esta carrera',
  //                       style: TextStyle(
  //                         fontSize: 14,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //               // Wrap(
  //               //   spacing: 24.0, // gap between adjacent chips
  //               //   runSpacing: 14.0, // gap between lines
  //               //   children: widget.horses.map(
  //               //     (horseNumber) {
  //               //       return HorseOption(
  //               //         number: horseNumber,
  //               //         onSelect: () {
  //               //           setState(() {
  //               //             if (!widget.multiselection) {
  //               //               selectedHourses.clear();
  //               //               selectedHourses.add(horseNumber);
  //               //             } else if (selectedHourses.contains(horseNumber)) {
  //               //               selectedHourses.remove(horseNumber);
  //               //             } else {
  //               //               selectedHourses.add(horseNumber);
  //               //             }
  //               //           });
  //               //         },
  //               //         selected: selectedHourses.contains(horseNumber),
  //               //       );
  //               //     },
  //               //   ).toList(),
  //               // ),
  //               Flexible(
  //                 child: Container(
  //                   color: Colors.blue,
  //                   alignment: Alignment.center,
  //                   constraints: BoxConstraints(maxWidth: 600, minWidth: 300),
  //                   child: Wrap(
  //                     spacing: 24.0, // gap between adjacent chips
  //                     runSpacing: 14.0, // gap between lines

  //                     children: widget.horses.map(
  //                       (horseNumber) {
  //                         return HorseOption(
  //                           number: horseNumber,
  //                           onSelect: () {
  //                             setState(() {
  //                               if (!widget.multiselection) {
  //                                 selectedHourses.clear();
  //                                 selectedHourses.add(horseNumber);
  //                               } else if (selectedHourses
  //                                   .contains(horseNumber)) {
  //                                 selectedHourses.remove(horseNumber);
  //                               } else {
  //                                 selectedHourses.add(horseNumber);
  //                               }
  //                             });
  //                           },
  //                           selected: selectedHourses.contains(horseNumber),
  //                         );
  //                       },
  //                     ).toList(),
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(width: 20),
  //               SizedBox(
  //                 width: 200,
  //                 child: ColoredBox(
  //                   color: AppColors.white,
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.end,
  //                     children: [
  //                       ElevatedButton(
  //                         onPressed: () {},
  //                         child: const Text('Carrera Anterior'),
  //                       ),
  //                       const SizedBox(height: 8),
  //                       ElevatedButton(
  //                         onPressed: () {},
  //                         child: const Text('Siguiente Carrera'),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           );
  //         }
  //         return Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Text(
  //                   'Carrera ${widget.raceNumber}',
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Expanded(child: Container()),
  //                 Text(
  //                   '${widget.raceNumber} de 6',
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             const SizedBox(height: 8),
  //             const Text(
  //               'Selecciona un caballo para esta carrera',
  //               style: TextStyle(
  //                 fontSize: 14,
  //               ),
  //             ),
  //             const SizedBox(height: 16),
  //             Center(
  //               child: Wrap(
  //                 spacing: 24.0, // gap between adjacent chips
  //                 runSpacing: 14.0, // gap between lines
  //                 children: widget.horses.map(
  //                   (horseNumber) {
  //                     return HorseOption(
  //                       number: horseNumber,
  //                       onSelect: () {
  //                         setState(() {
  //                           if (!widget.multiselection) {
  //                             selectedHourses.clear();
  //                             selectedHourses.add(horseNumber);
  //                           } else if (selectedHourses.contains(horseNumber)) {
  //                             selectedHourses.remove(horseNumber);
  //                           } else {
  //                             selectedHourses.add(horseNumber);
  //                           }
  //                         });
  //                       },
  //                       selected: selectedHourses.contains(horseNumber),
  //                     );
  //                   },
  //                 ).toList(),
  //               ),
  //             ),
  //           ],
  //         );
  //       }),
  //     ),
  //   );
  // }
}
