import 'package:e_fecta/domain/entities/track.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/common/header/cubit/header_cubit.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HeaderCubit>();
    return BlocConsumer<HeaderCubit, HeaderState>(
      listener: (context, state) {
        if (state is HeaderInfoChanged) {
          if (state.adminActive) {
            context.read<AdminCubit>().setTrack(state.selectedTrack.id);
          } else {
            context.read<PlaysCubit>().setTrack(state.selectedTrack.id);
          }
        }
      },
      builder: (context, state) {
        return AppBar(
          title: Row(
            children: [
              const Text('E-Fecta'),
              const SizedBox(
                width: 50,
              ),
              if (state is HeaderInfoChanged) ...{
                DropdownButton<String>(
                  value: state.selectedTrack.id,
                  onChanged: (newValue) {
                    if (newValue != null) {
                      context.read<HeaderCubit>().changeTrack(newValue);
                    }
                  },
                  items: state.tracks.map((Track track) {
                    return DropdownMenuItem<String>(
                      value: track.id,
                      child: Text(track.name),
                    );
                  }).toList(),
                )
              }
            ],
          ),
          actions: [
            if (state is HeaderInfoChanged) ...{
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Center(
                  child: Text(
                    'Tokens: ${state.user.tokens}',
                  ),
                ),
              ),
            },
            if (state is HeaderInfoChanged && state.user.isAdmin) ...{
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: TextButton(
                  onPressed: () {
                    if (state.adminActive) {
                      cubit.leaveAdminMode();
                    } else {
                      cubit.displayRaceConfiguration();
                    }
                  },
                  child: Text(
                    state.adminActive
                        ? 'Salir del Administrador'
                        : 'Modo Administrador',
                  ),
                ),
              ),
            },
            // GestureDetector(
            //   // onTap: () =>
            //   //     context.read<HeaderCubit>().displayRaceConfiguraiton(),
            //   onTap: () => Scaffold.of(context).openEndDrawer(),
            //   child: const SizedBox(
            //     width: 50,
            //     child: Icon(Icons.account_circle_rounded),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
