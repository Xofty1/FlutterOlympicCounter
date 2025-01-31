import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:olympic_counter/domain/models/BiathlonParticipant.dart';
import 'dart:io';
import 'package:path/path.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text("METANIT.COM")),
      body: const MainView(),
    ),
  ));
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Hello, Flutter!"),
          const Text("afdaf"),
          ElevatedButton(
            onPressed: () {
              pickAndReadExcel();
            },
            child: const Text('Выбрать файл Excel'),
          ),
        ],
      ),
    );
  }
}

Future<void> pickAndReadExcel() async {
  // Открываем диалог для выбора файла
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['xls', 'xlsx'],
  );
  List<BiathlonParticipant> lis = [];
  if (result != null) {
    // Получаем файл
    File file = File(result.files.single.path!);

    // Чтение данных из Excel
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    // Прочитаем данные из всех листов
    for (var table in excel.tables.keys) {
      print('Лист: $table'); // Имя листа
      var rows = excel.tables[table]?.rows;

      // Пройдем по всем строкам, начиная с первой (можно добавить проверку на заголовки)
      if (rows != null) {
        for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
          print(rows[rowIndex]);
          print(rows[rowIndex][4]?.value.runtimeType);
          int finishTime = convertToMilliseconds(rows[rowIndex][4]!.value.toString());
          int startTime = convertToMilliseconds(rows[rowIndex][5]!.value.toString());

          lis.add(BiathlonParticipant(
              name: rows[rowIndex][1]!.value.toString(),
              year: int.tryParse(rows[rowIndex][2]!.value.toString()),
              squadNumber: int.tryParse(rows[rowIndex][3]!.value.toString()),
              finishTime: finishTime,
              startTime: startTime,
              penaltyLoopNumber: int.tryParse(rows[rowIndex][6]!.value.toString()),
              totalTime: countTotalTime(finishTime, startTime)));
        }
        print(lis.last.name);
      }

    }
  } else {
    print("Файл не выбран.");
  }
}

int countTotalTime(int finishTime, int startTime) {
  return finishTime - startTime;
}

int convertToMilliseconds(String time) {
  // Разделяем строку на минуты, секунды и миллисекунды
  print(time);
  List<String> timeParts = time.split('.');
  print(" ");
print(timeParts);
  // Преобразуем строки в целые числа
  int minutes = int.parse(timeParts[0]);
  int seconds = int.parse(timeParts[1]);
  int milliseconds = int.parse(timeParts[2]);

  // Переводим в миллисекунды
  int totalMilliseconds =
      (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;

  return totalMilliseconds;
}
