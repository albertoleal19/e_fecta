import 'package:e_fecta/presentation/common/horse_option.dart';
import 'package:e_fecta/presentation/common/race.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EfectaApp());
}

class EfectaApp extends StatelessWidget {
  const EfectaApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Fecta',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(title: 'e-Fecta'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.title),
            const SizedBox(
              width: 50,
            ),
            const Chip(label: Text('Gulfstream Park'))
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
        leading: const SizedBox(
          width: 50,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: ListView(
            children: const [
              Race(
                raceNumber: 1,
                horses: [1, 3, 5, 6, 7, 8, 9, 10, 13, 14],
                selectedHorse: 9,
              ),
              Race(
                raceNumber: 2,
                horses: [2, 4, 5, 6, 8],
              ),
              Race(
                raceNumber: 3,
                horses: [1, 2, 3, 4, 5, 6, 8, 11, 12],
                selectedHorse: 4,
              ),
              Race(
                raceNumber: 4,
                horses: [1, 3, 5, 6, 7, 8, 9, 12],
                selectedHorse: 9,
              ),
              Race(
                raceNumber: 5,
                horses: [1, 3, 4, 5, 6, 7, 8, 9],
              ),
              Race(
                raceNumber: 6,
                horses: [8, 9, 10, 13, 14],
                selectedHorse: 13,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
