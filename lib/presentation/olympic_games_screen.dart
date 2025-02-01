import 'package:flutter/material.dart';

class OlympicGamesScreen extends StatelessWidget {
  const OlympicGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Олимпийские игры'),
      ),
      body: const Center(
        child: Text('Экран для подсчета Олимпийских игр'),
      ),
    );
  }
}
