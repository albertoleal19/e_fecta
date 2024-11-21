import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/admin/bloc/cubit/admin_cubit.dart';
import 'package:e_fecta/presentation/common/header/cubit/header_cubit.dart';
import 'package:e_fecta/presentation/common/login/login_screen.dart';
import 'package:e_fecta/presentation/plays/cubit/plays_cubit.dart';
import 'package:e_fecta/presentation/plays/play_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EfectaApp());
}

class EfectaApp extends StatelessWidget {
  const EfectaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Fecta',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.darkGreen,
          background: AppColors.darkBlue,
          onBackground: AppColors.white,
          onPrimary: AppColors.white,
          secondary: AppColors.green,
          onSecondary: AppColors.white,
          error: AppColors.errorRed,
          onError: AppColors.white,
          surface: AppColors.darkGreen,
          onSurface: AppColors.white,
        ),
        radioTheme:
            RadioThemeData(fillColor: MaterialStateProperty.all(Colors.black)
                // fillColor: WidgetStateProperty.resolveWith(
                //   (states) {
                //     return Colors.black;
                //   },
                // ),
                ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(AppColors.lightGreen),
            // foregroundColor: WidgetStateProperty.resolveWith(
            //   (states) {
            //     return AppColors.lightGreen;
            //   },
            // ),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.lightGreen),
            foregroundColor: MaterialStateProperty.all(AppColors.darkBlue),

            // backgroundColor: WidgetStateProperty.resolveWith(
            //   (states) {
            //     return AppColors.lightGreen;
            //   },
            // ),
            // foregroundColor: WidgetStateProperty.resolveWith(
            //   (states) {
            //     return AppColors.darkBlue;
            //   },
            // ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ),
      ),
      home: SelectionArea(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<PlaysCubit>(
              create: (BuildContext context) => PlaysCubit(),
            ),
            BlocProvider<HeaderCubit>(
              create: (BuildContext context) => HeaderCubit()..loadInfo(),
            ),
            BlocProvider<AdminCubit>(
              create: (BuildContext context) => AdminCubit(),
            ),
          ],
          child: const PlayScreen(),
        ),
      ),
    );
  }
}
