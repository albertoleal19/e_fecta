import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/core/size_contants.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/admin/raceday_list_item.dart';
import 'package:e_fecta/presentation/common/header/cubit/header_cubit.dart';
import 'package:e_fecta/presentation/common/race/race.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _tokensPerTicket = 1;
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final isCompressedView = screenWidth <= WindowSizeContants.medium;
    final adminCubit = context.read<AdminCubit>()..loadRacedaysInfo();
    return Column(
      children: [
        BlocBuilder<AdminCubit, AdminState>(
          builder: (context, state) {
            return Container(
              alignment:
                  isCompressedView ? Alignment.centerRight : Alignment.center,
              color: AppColors.green,
              padding:
                  const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20.0),
              child: Container(
                constraints: const BoxConstraints(
                  minWidth: 296,
                  minHeight: 196,
                  maxWidth: 800,
                ),
                padding: const EdgeInsets.all(30.0),
                color: AppColors.darkGreen,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Configuracion de Carreras',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Selecciona el dia y hora de las carreras.',
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final newDate = await pickDate(
                                context,
                                _selectedDateTime,
                                _selectedDateTime.add(const Duration(days: 7)));

                            setState(() {
                              if (newDate != null) {
                                _selectedDateTime = DateTime(
                                  newDate.year,
                                  newDate.month,
                                  newDate.day,
                                  _selectedDateTime.hour,
                                  _selectedDateTime.minute,
                                );
                              }
                            });
                          },
                          child: Text(
                            '${_selectedDateTime.year}/${_selectedDateTime.month}/${_selectedDateTime.day}',
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () async {
                            final time = await pickTime(
                              context,
                              TimeOfDay(
                                hour: _selectedDateTime.hour,
                                minute: _selectedDateTime.minute,
                              ),
                            );
                            setState(() {
                              if (time != null) {
                                _selectedDateTime = DateTime(
                                  _selectedDateTime.year,
                                  _selectedDateTime.month,
                                  _selectedDateTime.day,
                                  time.hour,
                                  time.minute,
                                );
                              }
                            });
                          },
                          child: Text(
                            '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selecciona el numero de tokens por ticket',
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<int>(
                      value: _tokensPerTicket,
                      onChanged: (newValue) {
                        if (newValue != null) {
                          setState(() {
                            _tokensPerTicket = newValue;
                          });
                        }
                      },
                      items: List<int>.from([1, 2, 3, 4, 5]).map((int value) {
                        return DropdownMenuItem<int>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Selecciona los caballos participantes por carrera.',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ...List<Widget>.generate(
                      6,
                      (index) {
                        final List<int> options =
                            List.generate(14, (index) => index + 1);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Carrera ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Race(
                              raceNumber: index,
                              horses: options,
                              selectionConfig: SelectionConfig.multi,
                              selectedHorses: [],
                              onSelectionChanged: (List<int> selected) {
                                adminCubit.setSelection(
                                    optionSelected: selected, race: index);
                              },
                            ),
                            if (index < 5) ...[
                              const SizedBox(height: 12),
                              const Divider(),
                            ]
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    if (state is AdminInputErrorState) ...[
                      const Text(
                        'No puedes seleccionar mas opciones, no tienes tokens suficientes.',
                        style: TextStyle(
                            color: AppColors.errorYellow, fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Center(
                      child: SizedBox(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () =>
                                  context.read<HeaderCubit>().leaveAdminMode(),
                              child: const Text('Cancelar'),
                            ),
                            const VerticalDivider(),
                            ElevatedButton(
                              onPressed: () => adminCubit.createRaceday(
                                tokensPerTicket: _tokensPerTicket,
                                closingTime: _selectedDateTime,
                              ),
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
          },
        ),
        BlocBuilder<AdminCubit, AdminState>(
          buildWhen: (previous, current) =>
              current is AdminConfiguredRacedaysLoaded,
          builder: (context, state) {
            return Container(
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
                      'Jornadas Configuradas',
                      style: TextStyle(fontSize: 48),
                    ),
                  ),
                  Center(
                    child: Container(
                      color: AppColors.darkBlue,
                      constraints: const BoxConstraints(maxWidth: 1000),
                      height: 730,
                      child: Builder(builder: (context) {
                        if (state is AdminConfiguredRacedaysLoaded) {
                          return ListView.separated(
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return RaceListItem(
                                raceday: state.racedays[index],
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const ColoredBox(
                                color: AppColors.darkerGreen,
                                child: Divider(),
                              );
                            },
                            itemCount: state.racedays.length,
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Future<DateTime?> pickDate(
          BuildContext context, DateTime firstDate, DateTime lastDate) =>
      showDatePicker(
          context: context, firstDate: firstDate, lastDate: lastDate);

  Future<TimeOfDay?> pickTime(BuildContext context, TimeOfDay initialTime) =>
      showTimePicker(context: context, initialTime: initialTime);
}
