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
    // context.read<PlaysCubit>().getRacedayConfig();
    return BlocConsumer<HeaderCubit, HeaderState>(
      listener: (context, state) {
        if (state is HeaderInfoLoaded) {
          context.read<PlaysCubit>().setTrack(state.selectedTrack.id);
          context.read<AdminCubit>().setTrack(state.selectedTrack.id);
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
              if (state is HeaderInfoLoaded) ...{
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
                ),
              },

              // BlocBuilder<HeaderCubit, HeaderState>(
              //   builder: (context, state) {
              //     if (state is HeaderInfoLoaded) {
              //       return Wrap(
              //         spacing: 6,
              //         children: [
              //           ...state.tracks.map((e) => Chip(label: Text(e.name)))
              //         ],
              //         // children: const [
              //         //   Chip(label: Text('Gulfstream Park')),
              //         //   Chip(label: Text('La Rinconada'))
              //         // ],
              //       );
              //     }
              //     return Container();
              //   },
              // )
              // Expanded(
              //   child: ListView(
              //     scrollDirection: Axis.horizontal,
              //     children: const [
              //       Chip(label: Text('Gulfstream Park')),
              //       Chip(label: Text('La Rinconada'))
              //     ],
              //   ),
              // ),
            ],
          ),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(kToolbarHeight),
          //   child: ListView(
          //     scrollDirection: Axis.horizontal,
          //     children: const [
          //       Chip(label: Text('Gulfstream Park')),
          //       Chip(label: Text('La Rinconada'))
          //     ],
          //   ),
          // ),
          actions: [
            if (state is HeaderInfoLoaded) ...{
              Center(
                child: Text(
                  '\$ ${state.user.tokens}',
                ),
              ),
            },
            const SizedBox(
              width: 30,
            ),
            GestureDetector(
              // onTap: () =>
              //     context.read<HeaderCubit>().displayRaceConfiguraiton(),
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: const SizedBox(
                width: 50,
                child: Icon(Icons.account_circle_rounded),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
