import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
                    return Column(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(flex: 6, child: UserInfo()),
                              Flexible(
                                flex: 4,
                                child: Container(
                                  color: AppColors.errorRed,
                                  width: 300,
                                ),
                                // child: TicketInfo(
                                //   maxWidth: 300,
                                //   padding: EdgeInsets.only(right: 20),
                                // ),
                              ),
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
                        Expanded(flex: 6, child: UserInfo()),
                        Expanded(
                            flex: 4,
                            child: Center(
                                child: TicketInfo(
                                    padding: EdgeInsets.only(right: 20)))),
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
    return Column(
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
    );
  }
}

class TicketInfo extends StatelessWidget {
  const TicketInfo({
    Key? key,
    this.maxWidth = double.maxFinite,
    this.padding,
    this.options = const [],
  }) : super(key: key);

  final double maxWidth;
  final EdgeInsets? padding;
  final List<int> options;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: padding,
          constraints: BoxConstraints(minWidth: 200, maxWidth: maxWidth),
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Carrera'),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        6,
                        (index) => TicketInfoItem(value: '${index + 1}a'),
                      ),
                      // children: [
                      //   TicketInfoItem(value: '1a'),
                      //   TicketInfoItem(value: '2a'),
                      //   TicketInfoItem(value: '3a'),
                      //   TicketInfoItem(value: '4a'),
                      //   TicketInfoItem(value: '5a'),
                      //   TicketInfoItem(value: '6a'),
                      // ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text('Caballo'),
                  const SizedBox(width: 30),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List<Widget>.generate(
                        options.length,
                        (index) => TicketInfoItem(value: '${options[index]}'),
                      ),
                      //children: [
                      // options.forEach((e) => TicketInfoItem(value: e.toString())),
                      // TicketInfoItem(value: '1'),
                      // TicketInfoItem(value: '2'),
                      // TicketInfoItem(value: '3'),
                      // TicketInfoItem(value: '4'),
                      // TicketInfoItem(value: '5'),
                      // TicketInfoItem(value: '6'),
                      //],
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
