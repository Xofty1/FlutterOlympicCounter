import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ResultScreen extends StatefulWidget {
  final String message;

  const ResultScreen({super.key, required this.message});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Результаты'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            widget.message,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center, // Выравнивание по центру
          ),
        ),
      ),
    );
  }
}

