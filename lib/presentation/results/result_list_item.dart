import 'package:e_fecta/core/app_colors.dart';
import 'package:flutter/material.dart';

class ResultListItem extends StatelessWidget {
  const ResultListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: AppColors.darkerGreen,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfo(),
                    TicketInfo(),
                    // Divider(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 66,
            color: AppColors.green,
            child: Column(
              children: [
                Expanded(child: Text('6')),
                // Divider(),
              ],
            ),
          )
        ],
      ),
    );
    // return Container(
    //   // constraints: const BoxConstraints(maxHeight: 200),
    //   color: AppColors.darkerGreen,
    //   child: Column(
    //     children: [
    //       IntrinsicHeight(
    //         child: Row(
    //           children: [
    //             const Expanded(
    //               child: Column(
    //                 mainAxisSize: MainAxisSize.min,
    //                 children: [
    //                   UserInfo(),
    //                   TicketInfo(),
    //                 ],
    //               ),
    //             ),
    //             Container(
    //               color: AppColors.green,
    //               alignment: Alignment.topCenter,
    //               width: 66,
    //               child: const Text('6'),
    //             )
    //           ],
    //         ),
    //       ),
    //       Divider(),
    //     ],
    //   ),
    // );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Usuario'),
        SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('JONA102'),
            Text('6764212-335019822'),
          ],
        )
      ],
    );
  }
}

class TicketInfo extends StatelessWidget {
  const TicketInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: const Column(
        children: [
          Row(
            children: [
              Text('Carrera'),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('1'),
                    Text('2'),
                    Text('3'),
                    Text('4'),
                    Text('5'),
                    Text('6'),
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text('Caballo'),
              SizedBox(width: 30),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('1'),
                    Text('2'),
                    Text('3'),
                    Text('4'),
                    Text('5'),
                    Text('6'),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
