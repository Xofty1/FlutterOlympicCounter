import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:olympic_counter/domain/models/OlympicParticipant.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import 'package:path/path.dart' as path;

import '../di.dart';
import '../models/BiathlonParticipant.dart';

class FileService {
  final TimeService _timeService = getIt<TimeService>();

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

  Future<void> saveToExcelBiathlon(
      List<List<BiathlonParticipant>> groupedBiathlonists,
      List<List<int>> years) async {
    var excel = Excel.createExcel();
    excel.delete('Sheet1');
    for (int i = 0; i < groupedBiathlonists.length; i++) {
      String sheetName = "${years[i][0]}-${years[i][1]}";
      var sheet = excel[sheetName];

      sheet.appendRow([
        "Имя",
        "Год рождения",
        "Номер",
        "Финишное время",
        "Стартовое время",
        "Штрафные круги",
        "Общее время",
        "Место"
      ]);
      int place = 1;
      sheet.appendRow([
        groupedBiathlonists[i][0].name,
        groupedBiathlonists[i][0].year,
        groupedBiathlonists[i][0].squadNumber,
        _timeService
            .convertFromMilliseconds(groupedBiathlonists[i][0].finishTime),
        _timeService
            .convertFromMilliseconds(groupedBiathlonists[i][0].startTime),
        groupedBiathlonists[i][0].penaltyLoopNumber,
        _timeService
            .convertFromMilliseconds(groupedBiathlonists[i][0].totalTime),
        place
      ]);
      for (int j = 1; j < groupedBiathlonists[i].length; j++) {
        var participant = groupedBiathlonists[i][j];
        if (participant.totalTime != groupedBiathlonists[i][j - 1].totalTime) {
          place++;
        }
        sheet.appendRow([
          participant.name,
          participant.year,
          participant.squadNumber,
          _timeService.convertFromMilliseconds(participant.finishTime),
          _timeService.convertFromMilliseconds(participant.startTime),
          participant.penaltyLoopNumber,
          _timeService.convertFromMilliseconds(participant.totalTime),
          place
        ]);
      }

      // Позволяем пользователю выбрать директорию для сохранения
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        print("Пользователь не выбрал директорию.");
        return;
      }

      // Формируем путь к файлу
      final filePath = path.join(selectedDirectory, 'biathlon_results.xlsx');

      // Сохраняем файл
      File file = File(filePath);
      await file.writeAsBytes(excel.encode()!);
      print("Файл сохранен: $filePath");
    }
  }

  Future<void> saveToExcelOlympic(
      List<List<OlympicParticipant>> groupedOlympic,
      List<List<int>> years) async {
    var excel = Excel.createExcel();
    excel.delete('Sheet1');
    for (int i = 0; i < groupedOlympic.length; i++) {
      String sheetName = "${years[i][0]}-${years[i][1]}";
      var sheet = excel[sheetName];

      sheet.appendRow([
        "Имя",
        "Год рождения",
        "Номер",
        "Финишное время",
        "Стартовое время",
        "Штрафные круги",
        "Общее время",
        "Место"
      ]);
      int place = 1;
      sheet.appendRow([
        groupedOlympic[i][0].name,
        groupedOlympic[i][0].year,
        groupedOlympic[i][0].squadNumber,
        _timeService
            .convertFromMilliseconds(groupedOlympic[i][0].finishTime),
        _timeService
            .convertFromMilliseconds(groupedOlympic[i][0].startTime),
        groupedOlympic[i][0].penaltyLoopNumber,
        _timeService
            .convertFromMilliseconds(groupedOlympic[i][0].totalTime),
        place
      ]);
      for (int j = 1; j < groupedOlympic[i].length; j++) {
        var participant = groupedOlympic[i][j];
        if (participant.totalTime != groupedOlympic[i][j - 1].totalTime) {
          place++;
        }
        sheet.appendRow([
          participant.name,
          participant.year,
          participant.squadNumber,
          _timeService.convertFromMilliseconds(participant.finishTime),
          _timeService.convertFromMilliseconds(participant.startTime),
          participant.penaltyLoopNumber,
          _timeService.convertFromMilliseconds(participant.totalTime),
          place
        ]);
      }

      // Позволяем пользователю выбрать директорию для сохранения
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        print("Пользователь не выбрал директорию.");
        return;
      }

      // Формируем путь к файлу
      final filePath = path.join(selectedDirectory, 'biathlon_results.xlsx');

      // Сохраняем файл
      File file = File(filePath);
      await file.writeAsBytes(excel.encode()!);
      print("Файл сохранен: $filePath");
    }
  }
}