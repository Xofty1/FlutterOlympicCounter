import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:olympic_counter/domain/di.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import '../models/BiathlonParticipant.dart';


class FileService{
  final TimeService _timeService = getIt<TimeService>();
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
            int finishTime = _timeService.convertToMilliseconds(rows[rowIndex][4]!.value.toString());
            int startTime = _timeService.convertToMilliseconds(rows[rowIndex][5]!.value.toString());

            lis.add(BiathlonParticipant(
                name: rows[rowIndex][1]!.value.toString(),
                year: int.tryParse(rows[rowIndex][2]!.value.toString()),
                squadNumber: int.tryParse(rows[rowIndex][3]!.value.toString()),
                finishTime: finishTime,
                startTime: startTime,
                penaltyLoopNumber: int.tryParse(rows[rowIndex][6]!.value.toString()),
                totalTime: _timeService.countTotalTime(finishTime, startTime)));
          }
          print(lis.last.name);
        }

      }
    } else {
      print("Файл не выбран.");
    }
  }
}