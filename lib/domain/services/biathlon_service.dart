import 'package:excel/excel.dart';
import 'package:olympic_counter/domain/services/file_service.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import '../di.dart';
import '../models/BiathlonParticipant.dart';

class BiathlonService {
  String message = '';
  final TimeService _timeService = getIt<TimeService>();
  List<List<BiathlonParticipant>> groupedBiathlonists = [];

  Future<String> execute(List<List<int>> years) async {
    FileService fileService = FileService();
    Excel? excel = await fileService.pickAndGetExcel();

    if (excel == null) {
      return "Файл не выбран";
    }

    bool isDataProcessed = await processExcelData(excel, years);
    if (isDataProcessed) {
      return await fileService.saveToExcelBiathlon(groupedBiathlonists, years);
    }

    return message;
  }

  Future<bool> processExcelData(Excel excel, List<List<int>> years) async {
    bool isDataProcessed = false;
    groupedBiathlonists = List.generate(years.length, (_) => []);

    for (var table in excel.tables.keys) {
      print('Лист: $table');
      var rows = excel.tables[table]?.rows;

      if (rows != null) {
        print("Количество строк в таблице: ${rows.length}");
        isDataProcessed = await processRows(rows, years) || isDataProcessed;

        for (int i = 0; i < groupedBiathlonists.length; i++) {
          print(
              "Группа ${i + 1}: ${groupedBiathlonists[i].length} биатлонистов");
          for (var participant in groupedBiathlonists[i]) {
            print(
                "До сортировки: ${participant.name} - ${participant.totalTime}");
          }
        }

        sortByTime();

        print("Сортировка выполнена.");
        for (int i = 0; i < groupedBiathlonists.length; i++) {
          for (var participant in groupedBiathlonists[i]) {
            print(
                "После сортировки: ${participant.name} - ${participant.totalTime}");
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
        if (row.length < 7) continue;
        print("50");
        int finishTime =
            _timeService.convertToMilliseconds(row[4]?.value.toString() ?? '');
        print("50.5");
        int startTime =
            _timeService.convertToMilliseconds(row[5]?.value.toString() ?? '');
        print("50.7");
        int? year = int.tryParse(row[2]?.value.toString() ?? '');
        print("51");
        BiathlonParticipant participant = BiathlonParticipant(
          name: row[1]?.value.toString() ?? '',
          year: year,
          squadNumber: int.tryParse(row[3]?.value.toString() ?? ''),
          finishTime: finishTime,
          startTime: startTime,
          penaltyLoopNumber: int.tryParse(row[6]?.value.toString() ?? ''),
          totalTime: _timeService.countTotalTime(finishTime, startTime),
        );
        print("52");
        for (int i = 0; i < years.length; i++) {
          if (year != null && years[i][0] <= year && years[i][1] >= year) {
            groupedBiathlonists[i].add(participant);
            print("Добавлен ${participant.name} в группу $i");
            break;
          }
        }
        print("53");

        isDataProcessed = true;
      } catch (e) {
        message = "Ошибка при обработке строки $rowIndex: $e";
        print("Ошибка при обработке строки $rowIndex: $e");
      }
    }

    return isDataProcessed;
  }

  void sortByTime() {
    for (int i = 0; i < groupedBiathlonists.length; i++) {
      groupedBiathlonists[i].sort((a, b) => (a.totalTime ?? double.maxFinite)
          .compareTo(b.totalTime ?? double.maxFinite));
    }
  }
}
