import 'package:flutter/material.dart';
import 'package:ex01/sala_repete.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jogo Repete'),
        ),
        body: const Center(
          child: SalaRepete(),
        ),
      ),
    );
  }
}
