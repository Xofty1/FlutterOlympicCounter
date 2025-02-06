import 'package:flutter/material.dart';
import 'package:olympic_counter/domain/services/biathlon_service.dart';
import 'package:olympic_counter/domain/services/olympic_games_service.dart';
import 'package:olympic_counter/presentation/olympic_games_screen.dart';

class BiathlonScreen extends StatefulWidget {
  const BiathlonScreen({super.key});

  @override
  _BiathlonScreenState createState() => _BiathlonScreenState();
}

class _BiathlonScreenState extends State<BiathlonScreen> {
  // Список для хранения пар годов
  List<List<int>> yearPairs = [[0,0]];

  // Контроллеры для текстовых полей
  List<TextEditingController> startYearControllers = [TextEditingController()];
  List<TextEditingController> endYearControllers = [TextEditingController()];

  @override
  void initState() {
    super.initState();
    // Инициализация списка yearPairs
    _initializeYearPairs();
  }

  void _initializeYearPairs() {
    final currentYear = DateTime.now().year; // Текущий год
    final startYear = currentYear - 16; // Год, который был 16 лет назад

    // Очищаем списки перед инициализацией
    yearPairs.clear();
    startYearControllers.clear();
    endYearControllers.clear();

    // Создаем пары годов
    for (int i = 0; i < 10; i+=2) {
      final start = startYear + i;
      final end = start + 1;
      yearPairs.add([start, end]);

      // Добавляем контроллеры для текстовых полей
      startYearControllers.add(TextEditingController(text: start.toString()));
      endYearControllers.add(TextEditingController(text: end.toString()));
    }
  }

  // Функция для добавления новой строки
  void _addRow() {
    setState(() {
      startYearControllers.add(TextEditingController());
      endYearControllers.add(TextEditingController());
      yearPairs.add([0, 0]); // Добавляем пустую пару
    });
  }

  void _deleteRow() {
    if(yearPairs.length != 1) {
      setState(() {
        startYearControllers.removeLast();
        endYearControllers.removeLast();
        yearPairs.removeLast();
      });
    }
  }

  // Функция для считывания всех годов и записи их в массив
  void _saveYears() {
    setState(() {
      for (int i = 0; i < yearPairs.length; i++) {
        int startYear = int.tryParse(startYearControllers[i].text) ?? 0;
        int endYear = int.tryParse(endYearControllers[i].text) ?? 0;
        yearPairs[i] = [startYear, endYear];
      }
      // Вывод массива в консоль для проверки
      print(yearPairs);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Биатлон'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        // Добавляем padding
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 10, // Отступ между столбцами
                  columns: [
                    DataColumn(
                      label: const Center(
                        child: Text('Год начала'),
                      ),
                    ),
                    DataColumn(
                      label: const Center(
                        child: Text('Год конца'),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    yearPairs.length,
                    (index) => DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            child: TextField(
                              controller: startYearControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Введите год начала',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  yearPairs[index][0] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                        DataCell(
                          SizedBox(
                            child: TextField(
                              controller: endYearControllers[index],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Введите год конца',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  yearPairs[index][1] =
                                      int.tryParse(value) ?? 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addRow,
                ),
                ElevatedButton(
                  onPressed: () async {
                    _saveYears();
                    print("Года ${yearPairs}");
                    bool result = await BiathlonService().execute(yearPairs);
                    if (result) {
                      print("Данные успешно обработаны.");
                    } else {
                      print("Ошибка при обработке данных.");
                    }
                  },
                  child: const Text('Посчитать биатлон'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    bool result = await OlympicGamesService().execute(yearPairs);
                    if (result) {
                      print("Данные успешно обработаны.");
                    } else {
                      print("Ошибка при обработке данных.");
                    }
                  },
                  child: const Text('Посчитать игры'),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _deleteRow,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
