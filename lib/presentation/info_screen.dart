import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

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
