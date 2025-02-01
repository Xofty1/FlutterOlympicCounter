import 'package:flutter/material.dart';

class BiathlonScreen extends StatelessWidget {
  const BiathlonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Биатлон'),
      ),
      body: const Center(
        child: Text('Экран для подсчета Биатлона'),
      ),
    );
  }
}
