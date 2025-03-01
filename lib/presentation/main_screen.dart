import 'package:flutter/material.dart';
import 'package:olympic_counter/domain/services/file_service.dart';
import 'info_screen.dart';
import 'years_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная страница'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline), // Кнопка ?
            onPressed: () {
              // Действие для кнопки ? (например, показать всплывающее сообщение или экран справки)
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Справка'),
                    content: const Text('Здесь будет информация о приложении.'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(height: 20), // Отступ между кнопками
            ElevatedButton(
              onPressed: () {
                // Переход на экран Биатлона
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BiathlonScreen()),
                );
              },
              child: const Text('Посчитать результаты соревнований'),
            ),
            ElevatedButton(
              onPressed: () {
                // Переход на экран Олимпийских игр
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const InfoScreen()),
                );
              },
              child: const Text('Как правильно посчитать результаты'),
            ),
          ],
        ),
      ),
    );
  }
}
