import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:olympic_counter/domain/models/OlympicParticipant.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

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
      for (int j = 0; j < groupedBiathlonists[i].length; j++) {
        var participant = groupedBiathlonists[i][j];

        if (j > 0 && participant.totalTime != groupedBiathlonists[i][j - 1].totalTime) {
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
    }

    // Получаем директорию для сохранения файла
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Не удалось получить директорию для сохранения.");
      return;
    }

    // Формируем путь к файлу
    final filePath = path.join(directory.path, 'biathlon_results.xlsx');

    // Сохраняем файл
    File file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
    print("Файл сохранен: $filePath");
  }

  Future<void> saveToExcelOlympic(
      List<List<OlympicParticipant>> groupedOlympic,
      List<List<int>> years) async {
    var excel = Excel.createExcel();
    excel.delete('Sheet1'); // Удаляем стандартный лист

    for (int i = 0; i < groupedOlympic.length; i++) {
      // Создаем имя листа на основе диапазона лет
      String sheetName = "${years[i][0]}-${years[i][1]}";
      var sheet = excel[sheetName];

      // Добавляем заголовки столбцов
      sheet.appendRow([
        "Имя",
        "Год рождения",
        "Номер команды",
        "Прыжки со скакалкой",
        "Броски мяча",
        "Сгиб-разгиб рук",
        "Прыжки в высоту",
        "Прыжки в длину",
        "Бег 60 м",
        "Общие баллы",
        "Место"
      ]);

      // Сортируем участников по общим баллам (points)
      groupedOlympic[i].sort((a, b) => b.points.compareTo(a.points));

      // Добавляем данные участников
      int place = 1;
      for (int j = 0; j < groupedOlympic[i].length; j++) {
        var participant = groupedOlympic[i][j];

        // Увеличиваем место, если баллы отличаются от предыдущего участника
        if (j > 0 && participant.points != groupedOlympic[i][j - 1].points) {
          place = j + 1;
        }

        sheet.appendRow([
          participant.name,
          participant.year,
          participant.squadNumber,
          participant.ropeJumping,
          participant.ballThrowing,
          participant.armFlexionExtension,
          participant.highJump,
          participant.longJump,
          _timeService.convertFromMillisecondsOfOlympics(participant.running60m),
          participant.points,
          place
        ]);
      }
    }

    // Позволяем пользователю выбрать директорию для сохранения
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      print("Не удалось получить директорию для сохранения.");
      return;
    }

    // Формируем путь к файлу
    final filePath = path.join(directory.path, 'olympic_games_results.xlsx');

    // Сохраняем файл
    File file = File(filePath);
    await file.writeAsBytes(excel.encode()!);
    print("Файл сохранен: $filePath");
  }
}