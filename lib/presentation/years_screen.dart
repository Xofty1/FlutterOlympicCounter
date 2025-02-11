import 'package:flutter/material.dart';
import 'package:olympic_counter/domain/services/biathlon_service.dart';
import 'package:olympic_counter/domain/services/olympic_games_service.dart';
import 'package:olympic_counter/presentation/result_screen.dart';

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
        title: const Text('Настройки соревнований'),
      ),
      body: Column(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addRow,
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      _saveYears();
                      print("Года ${yearPairs}");
                      String resultMessage = await BiathlonService().execute(yearPairs);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(message: resultMessage),
                        ),
                      );
                    },
                    child: const Text('Посчитать биатлон'),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () async {
                      String resultMessage = await OlympicGamesService().execute(yearPairs);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(message: resultMessage),
                        ),
                      );
                    },
                    child: const Text('Посчитать игры'),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: _deleteRow,
                  ),
                ),
              ],
            ),

          ],
        ),

    );
  }
}
