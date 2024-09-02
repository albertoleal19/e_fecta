import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/common/header/header.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:e_fecta/presentation/plays/play_selection.dart';
import 'package:e_fecta/presentation/results/result_list_item.dart';
import 'package:flutter/material.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: AppColors.green,
            height: MediaQuery.sizeOf(context).height,
            // padding: const EdgeInsets.only(left: 20.0, top: 20.0, bottom: 20.0),
            child: ListView(
              children: [
                const PlaySelection(
                  races: [
                    [1, 3, 5, 6, 8, 11, 12, 15],
                    [1, 2, 3, 4, 5, 12],
                    [1, 2, 3, 4, 5, 6, 8, 11, 12],
                    [2, 4, 5, 6, 14, 18, 20],
                    [1, 2, 3, 4, 5, 6, 8, 11, 12, 13, 16, 18],
                    [1, 2, 4, 5, 6, 8, 7, 9, 10, 11, 12, 15, 19]
                  ],
                ),
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
                      Container(
                        color: AppColors.darkBlue,
                        height: 500,
                        // child: UserInfo(),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return ResultListItem();
                            // return Row(
                            //   children: [
                            //     Expanded(
                            //       child: Column(
                            //         children: [
                            //           UserInfo(),
                            //           TicketInfo(),
                            //         ],
                            //       ),
                            //     ),
                            //     Container(
                            //       width: 40,
                            //       color: AppColors.darkGrey,
                            //     ),
                            //   ],
                            // );
                          },
                          itemCount: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1er Premio: 1500 und'),
                          Text('2do Premio: 750 und'),
                          Text('3er Premio: 250 und'),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Sabado 13 Sept 2022 -- 15:35'),
                        Text('Cierra en : 50 min'),
                      ],
                    ),
                  ],
                ),
                Container(
                  color: AppColors.darkBlue,
                  height: 260,
                  child: const Text('Footer'),
                ),
              ],
            ),
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {},
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ),
    );
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
