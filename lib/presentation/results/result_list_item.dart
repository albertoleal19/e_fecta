import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/domain/entities/ticket.dart';
import 'package:flutter/material.dart';

class ResultListItem extends StatelessWidget {
  const ResultListItem({
    Key? key,
    required this.ticket,
    required this.position,
  }) : super(key: key);

  final Ticket ticket;
  final int position;

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
                              Expanded(
                                flex: 6,
                                child: UserInfo(
                                  ticketId: ticket.number,
                                  username: ticket.username,
                                  position: position,
                                ),
                              ),
                              Flexible(
                                flex: 4,
                                child: TicketInfo2(
                                  options: ticket.selectedOptions,
                                  pts: ticket.points,
                                  maxWidth: 300,
                                  padding: const EdgeInsets.only(right: 20),
                                ),
                                // child: Container(
                                //   color: AppColors.errorRed,
                                //   width: 300,
                                // ),
                                // child: TicketInfo(
                                //   maxWidth: 300,
                                //   padding: EdgeInsets.only(right: 20),
                                // ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            flex: 6,
                            child: UserInfo(
                              ticketId: ticket.number,
                              username: ticket.username,
                              position: position,
                            )),
                        Expanded(
                          flex: 4,
                          child: TicketInfo2(
                            options: ticket.selectedOptions,
                            pts: ticket.points,
                            padding: const EdgeInsets.only(right: 20),
                          ),
                        ),
                        const Divider(),
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
            child: Column(
              children: [
                Expanded(child: Text('${ticket.totalPts}')),
                const Divider(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.ticketId,
    required this.username,
    required this.position,
  }) : super(key: key);

  final String ticketId;
  final String username;
  final int position;

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
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(username),
                        const SizedBox(height: 8.0),
                        Text(ticketId),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(username),
                        Expanded(child: Center(child: Text(ticketId))),
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

class TicketInfo2 extends StatelessWidget {
  const TicketInfo2({
    Key? key,
    this.maxWidth = double.maxFinite,
    this.padding,
    this.options = const [0, 0, 0, 0, 0, 0],
    this.pts = const [0, 0, 0, 0, 0, 0],
    this.showPtsRow = true,
  }) : super(key: key);

  final double maxWidth;
  final EdgeInsets? padding;
  final List<int> options;
  final List<int> pts;
  final bool showPtsRow;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30.0),
                  child: SizedBox(
                      width: 50,
                      child: Text(
                        'Carrera',
                        textAlign: TextAlign.end,
                      )),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List<Widget>.generate(
                        6,
                        (index) => TicketInfoItem(value: '${index + 1}a'),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 30.0),
                  child: SizedBox(
                      width: 50,
                      child: Text(
                        'Caballo',
                        textAlign: TextAlign.end,
                      )),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List<Widget>.generate(
                        options.length,
                        (index) => TicketInfoItem(value: '${options[index]}'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (showPtsRow) ...{
              Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 30.0),
                    child: SizedBox(
                        width: 50,
                        child: Text(
                          'Pts',
                          textAlign: TextAlign.end,
                        )),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ...List<Widget>.generate(
                          options.length,
                          (index) => TicketInfoItem(value: '${pts[index]}'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            }
          ],
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
    return Container(
      constraints: const BoxConstraints(minWidth: 15, maxHeight: 30),
      child: Text(
        value,
        textAlign: TextAlign.center,
      ),
    );
  }
}
