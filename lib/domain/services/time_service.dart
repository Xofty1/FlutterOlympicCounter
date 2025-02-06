class TimeService {
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

  String convertFromMilliseconds(int? time) {
    if (time == null) return "Error";
    int minutes = time ~/ 60000;
    time -= minutes * 60000;
    int seconds = time ~/ 1000;
    time -= seconds * 1000;
    return "$minutes.$seconds.$time";
  }
}
