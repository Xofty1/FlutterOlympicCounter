import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import '../models/BiathlonParticipant.dart';

class FileService{
  Future<Excel?> pickAndGetExcel() async {
    // Открываем диалог для выбора файла
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xls', 'xlsx'],
    );

    if (result != null) {
      // Получаем файл
      File file = File(result.files.single.path!);
      // Чтение данных из Excel
      var bytes = file.readAsBytesSync();
      return Excel.decodeBytes(bytes);
    }
    return null;
  }

  Future<void> saveToExcel(List<List<BiathlonParticipant>> groupedBiathlonists, List<List<int>> years) async {
    var excel = Excel.createExcel();

    for (int i = 0; i < groupedBiathlonists.length; i++) {
      String sheetName = "${years[i][0]}-${years[i][1]}";
      var sheet = excel[sheetName];

      sheet.appendRow([
        "Имя", "Год рождения", "Номер", "Финишное время", "Стартовое время", "Штрафные круги", "Общее время"
      ]);

      for (var participant in groupedBiathlonists[i]) {
        sheet.appendRow([
          participant.name,
          participant.year,
          participant.squadNumber,
          participant.finishTime,
          participant.startTime,
          participant.penaltyLoopNumber,
          participant.totalTime,
        ]);
      }
    }

    File file = File("biathlon_results.xlsx");
    await file.writeAsBytes(excel.encode()!);
    print("Файл сохранен: biathlon_results.xlsx");
  }
}