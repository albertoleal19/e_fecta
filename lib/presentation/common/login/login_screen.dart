import 'package:e_fecta/core/app_colors.dart';
import 'package:e_fecta/presentation/common/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isChecked = false;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Image.asset(
              'assets/image_login1.png',
            ),
          ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 21),
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Welcome back',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Login to your account',
                  ),
                  const SizedBox(height: 15),
                  BlocConsumer<LoginCubit, LoginState>(
                    listener: (context, state) {
                      if (state is LoginSuccess) {
                        context.go('/');
                      }
                    },
                    builder: (context, state) {
                      if (state is LoginFailed) {
                        return const Text(
                          'Error. Por favor revise sus credenciales',
                          style: TextStyle(
                            color: AppColors.errorRed,
                            fontSize: 16,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'abc@example.com',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    controller: usernameController,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      hintText: '********',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                    controller: passwordController,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _isChecked,
                              onChanged: onChanged,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                          ),
                        ],
                      ),
                      const SizedBox(width: 25),
                      const Text(
                        'Forgot password?',
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        print('Tap on Login ');

                        context.read<LoginCubit>().loginUser(
                            usernameController.text, passwordController.text);
                        // await FirebaseAuth.instance
                        //     .signInWithEmailAndPassword(
                        //   email: usernameController.text,
                        //   password: passwordController.text,
                        // );
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const PlayScreen(),
                        //   ),
                        // );
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                        }
                      }
                    },
                    //style: OutlinedButton.
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                    ),
                    child: const Text(
                      'Login now A',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () async {
                      try {
                        // await FirebaseAuth.instance
                        //     .createUserWithEmailAndPassword(
                        //   email: 'linofuenma+1@gmail.com',
                        //   password: '12345678',
                        // );
                        print('User Registered Successfuly');
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => const PlayScreen(),
                        //   ),
                        // );
                      } on FirebaseAuthException catch (e) {
                        print('Error on register: $e');
                      }
                    },
                    //style: OutlinedButton.
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 10,
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onChanged(bool? value) {
    setState(() {
      _isChecked = value!;
    });
  }
}
