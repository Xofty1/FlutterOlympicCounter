import 'package:flutter/material.dart';

import 'package:olympic_counter/presentation/main_screen.dart';

import 'domain/di.dart';

void main() {
  setupLocator();
  runApp(MaterialApp(
    home: Scaffold(
      body: const MainScreen(),
    ),
  ));
}
