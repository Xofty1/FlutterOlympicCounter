import 'package:excel/excel.dart';
import 'package:olympic_counter/domain/services/file_service.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import '../di.dart';
import '../models/BiathlonParticipant.dart';
import '../models/OlympicParticipant.dart';


class OlympicGamesService {
  final TimeService _timeService = getIt<TimeService>();
  List<List<OlympicParticipant>> groupedOlympics = [];

  Future<bool> execute(List<List<int>> years) async {
    FileService fileService = FileService();
    Excel? excel = await fileService.pickAndGetExcel();

    if (excel == null) {
      print("Файл не выбран.");
      return false;
    }

    bool isDataProcessed = await processExcelData(excel, years);
    await fileService.saveToExcelOlympic(groupedOlympics, years);

    return isDataProcessed;
  }

  Future<bool> processExcelData(Excel excel, List<List<int>> years) async {
    bool isDataProcessed = false;
    groupedOlympics = List.generate(years.length, (_) => []);

    for (var table in excel.tables.keys) {
      print('Лист: $table');
      var rows = excel.tables[table]?.rows;

      if (rows != null) {
        print("Количество строк в таблице: ${rows.length}");
        isDataProcessed = await processRows(rows, years) || isDataProcessed;

        for (int i = 0; i < groupedOlympics.length; i++) {
          print(
              "Группа ${i + 1}: ${groupedOlympics[i].length} биатлонистов");
          for (var participant in groupedOlympics[i]) {
            print(
                "До сортировки: ${participant.name}");
          }
        }

        countPlaces();

        print("Сортировка выполнена.");
        for (int i = 0; i < groupedOlympics.length; i++) {
          for (var participant in groupedOlympics[i]) {
            print(
                "После сортировки: ${participant.name}");
          }
        }
      }
    }

    return isDataProcessed;
  }

  Future<bool> processRows(
      List<List<Data?>> rows, List<List<int>> years) async {
    bool isDataProcessed = false;

    for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      try {
        var row = rows[rowIndex];
        if (row.length < 9) continue;
        int running60m =
        _timeService.convertToMillisecondsOfOlympic(row[9]?.value.toString() ?? '');
        int? year = int.tryParse(row[2]?.value.toString() ?? '');
        print("Год $year");

        OlympicParticipant participant = OlympicParticipant(
          name: row[1]?.value.toString() ?? '',
          year: year,
          squadNumber: int.tryParse(row[3]?.value.toString() ?? ''),
          ropeJumping: int.tryParse(row[4]?.value.toString() ?? '') ?? 0,
          ballThrowing: int.tryParse(row[5]?.value.toString() ?? '') ?? 0,
          armFlexionExtension: int.tryParse(row[6]?.value.toString() ?? '') ?? 0,
          highJump: int.tryParse(row[7]?.value.toString() ?? '') ?? 0,
          longJump: int.tryParse(row[8]?.value.toString() ?? '') ?? 0,
          running60m: running60m,
        );

        for (int i = 0; i < years.length; i++) {
          if (year != null && years[i][0] <= year && years[i][1] >= year) {
            groupedOlympics[i].add(participant);
            print("Добавлен ${participant.name} в группу $i");
            break;
          }
        }

        isDataProcessed = true;
      } catch (e) {
        print("Ошибка при обработке строки $rowIndex: $e");
      }
    }

    return isDataProcessed;
  }


  void countPlaces() {
    for (int i = 0; i < groupedOlympics.length; i++) {
      // Функция для подсчета баллов на основе критерия
      void calculatePoints(int Function(OlympicParticipant a, OlympicParticipant b) compareFunction) {
        groupedOlympics[i].sort(compareFunction); // Сортировка по критерию
        int points = 1;
        var previousParticipant = groupedOlympics[i][0];

        for (int j = 1; j < groupedOlympics[i].length; j++) {
          groupedOlympics[i][j].points += points; // Добавляем баллы
          if (compareFunction(previousParticipant, groupedOlympics[i][j]) != 0) {
            points++; // Увеличиваем баллы, если текущий результат отличается от предыдущего
          }
          previousParticipant = groupedOlympics[i][j];
        }
      }

      // Подсчет баллов для каждого вида спорта
      calculatePoints((a, b) => a.ropeJumping.compareTo(b.ropeJumping)); // Прыжки со скакалкой
      calculatePoints((a, b) => a.ballThrowing.compareTo(b.ballThrowing)); // Броски мяча
      calculatePoints((a, b) => a.armFlexionExtension.compareTo(b.armFlexionExtension)); // Сгиб разгиб рук
      calculatePoints((a, b) => a.highJump.compareTo(b.highJump)); // Прыжки в высоту
      calculatePoints((a, b) => a.longJump.compareTo(b.longJump)); // Прыжки в длину
      calculatePoints((a, b) => b.running60m.compareTo(a.running60m)); // Бег 60 м
    }
  }

}
