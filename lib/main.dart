import 'package:flutter/material.dart';
import 'package:jobsity_challenge/presentation/screens/home/home_screen.dart';

void main() {
  runApp(
    const TVMaze(),
  );
}

class TVMaze extends StatelessWidget {
  const TVMaze({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}
