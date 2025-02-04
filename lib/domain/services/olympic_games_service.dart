import 'package:excel/excel.dart';
import 'package:olympic_counter/domain/services/file_service.dart';
import 'package:olympic_counter/domain/services/time_service.dart';

import '../di.dart';
import '../models/BiathlonParticipant.dart';

class OlympicGamesService {
  List<List<int>> year = [];
  final TimeService _timeService = getIt<TimeService>();

  Future<bool> execute(List<List<int>> year) async {
    FileService fileService = FileService();
    Excel? excel = await fileService.pickAndGetExcel();

    if (excel == null) {
      print("Файл не выбран.");
      return false; // Возвращаем false, если файл не выбран
    }

    List<BiathlonParticipant> biathlonists = [];
    bool isDataProcessed = await readDataFromExcel(excel, biathlonists);

    if (biathlonists.isNotEmpty) {
      print("${biathlonists.last.totalTime} ${biathlonists.last.name}");
    }

    return isDataProcessed; // Возвращаем true, если данные успешно обработаны
  }

  Future<bool> readDataFromExcel(Excel excel, List<BiathlonParticipant> biathlonists) async {
    bool isDataProcessed = false;

    for (var table in excel.tables.keys) {
      print('Лист: $table'); // Имя листа
      var rows = excel.tables[table]?.rows;

      if (rows != null) {
        isDataProcessed = await readDataFromTable(rows, biathlonists) || isDataProcessed;
      }
    }

    return isDataProcessed;
  }

  Future<bool> readDataFromTable(List<List<Data?>> rows, List<BiathlonParticipant> biathlonists) async {
    bool isDataProcessed = false;

    for (var rowIndex = 1; rowIndex < rows.length; rowIndex++) {
      try {
        print(rows[rowIndex]);
        print(rows[rowIndex][4]?.value.runtimeType);

        int finishTime = _timeService.convertToMilliseconds(rows[rowIndex][4]!.value.toString());
        int startTime = _timeService.convertToMilliseconds(rows[rowIndex][5]!.value.toString());

        biathlonists.add(BiathlonParticipant(
          name: rows[rowIndex][1]!.value.toString(),
          year: int.tryParse(rows[rowIndex][2]!.value.toString()),
          squadNumber: int.tryParse(rows[rowIndex][3]!.value.toString()),
          finishTime: finishTime,
          startTime: startTime,
          penaltyLoopNumber: int.tryParse(rows[rowIndex][6]!.value.toString()),
          totalTime: _timeService.countTotalTime(finishTime, startTime),
        ));

        isDataProcessed = true; // Данные успешно обработаны
      } catch (e) {
        print("Ошибка при обработке строки $rowIndex: $e");
        // Продолжаем обработку следующих строк, даже если текущая строка содержит ошибку
      }
    }

    return isDataProcessed;
  }
}