import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:flutter/material.dart';

class ResultListItem extends StatelessWidget {
  const ResultListItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              color: AppColors.darkerGreen,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Builder(builder: (context) {
                  if (!isCompressedScreen) {
                    return const Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              UserInfo(),
                              TicketInfo(),
                            ],
                          ),
                        ),
                        Divider(),
                      ],
                    );
                  } else {
                    return const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        UserInfo(),
                        TicketInfo(),
                        Divider(),
                      ],
                    );
                  }
                }),
              ),
            ),
          ),
          Container(
            width: 66,
            color: AppColors.green,
            child: const Column(
              children: [
                Expanded(child: Text('6')),
                Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    return Expanded(
      flex: 60,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Usuario'),
              const SizedBox(width: 30),
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (isCompressedScreen) {
                      return const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('JONA102'),
                          SizedBox(height: 8.0),
                          Text('6764212-335019822'),
                        ],
                      );
                    } else {
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text('JONA102'),
                          Expanded(
                              child: Center(child: Text('6764212-335019822'))),
                        ],
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class TicketInfo extends StatelessWidget {
  const TicketInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    final isCompressedScreen = width < WindowSizeContants.compact;
    return Expanded(
      flex: 40,
      child: Align(
        alignment: isCompressedScreen ? Alignment.topLeft : Alignment.center,
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          constraints: const BoxConstraints(minWidth: 200, maxWidth: 300),
          child: const Column(
            children: [
              Row(
                children: [
                  Text('Carrera'),
                  SizedBox(width: 30),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TicketInfoItem(value: '1a'),
                        TicketInfoItem(value: '2a'),
                        TicketInfoItem(value: '3a'),
                        TicketInfoItem(value: '4a'),
                        TicketInfoItem(value: '5a'),
                        TicketInfoItem(value: '6a'),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TicketInfoItem(value: '1'),
                        TicketInfoItem(value: '2'),
                        TicketInfoItem(value: '3'),
                        TicketInfoItem(value: '4'),
                        TicketInfoItem(value: '5'),
                        TicketInfoItem(value: '6'),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketInfoItem extends StatelessWidget {
  const TicketInfoItem({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        constraints: const BoxConstraints(minWidth: 15, maxHeight: 30),
        child: Text(
          value,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
