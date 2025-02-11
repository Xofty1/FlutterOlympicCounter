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
    int milliseconds = 0;
    if (timeParts.length == 3) milliseconds = int.parse(timeParts[2]);

    // Переводим в миллисекунды
    int totalMilliseconds =
        (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;

    return totalMilliseconds;
  }

  int convertToMillisecondsOfOlympic(String time) {
    // Разделяем строку на минуты, секунды и миллисекунды
    print("Время $time");
    List<String> timeParts = time.split('.');
    int seconds = int.parse(timeParts[0]);
    int milliseconds = int.parse(timeParts[1]);

    // Переводим в миллисекунды
    int totalMilliseconds = (seconds * 1000) + milliseconds;

    return totalMilliseconds;
  }

  String convertFromMilliseconds(int? time) {
    if (time == null) return "Error";

    int minutes = time ~/ 60000;
    time %= 60000; // Оставшиеся миллисекунды

    int seconds = time ~/ 1000;
    int milliseconds = time % 1000; // Оставшиеся миллисекунды

    // Форматируем секунды и миллисекунды
    String strSeconds = seconds.toString().padLeft(2, '0');
    String strMilliseconds = milliseconds.toString().padLeft(2, '0');

    return "$minutes.$strSeconds.$strMilliseconds"; // Формат MM:SS.mmm
  }


  String convertFromMillisecondsOfOlympics(int? time) {
    if (time == null) return "Error";
    int seconds = time ~/ 1000;
    time -= seconds * 1000;
    return "$seconds,${time.toString().padRight(2, '0')}";
  }
}
