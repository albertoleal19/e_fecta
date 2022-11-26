import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          const Text('e-Fecta'),
          const SizedBox(
            width: 50,
          ),
          Wrap(
            spacing: 6,
            children: const [
              Chip(label: Text('Gulfstream Park')),
              Chip(label: Text('La Rinconada'))
            ],
          )
        ],
      ),
      actions: const [
        Center(
          child: Text(
            '\$ 100 und',
          ),
        ),
        SizedBox(
          width: 30,
        ),
        SizedBox(
          width: 50,
          child: Icon(Icons.account_circle_rounded),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
