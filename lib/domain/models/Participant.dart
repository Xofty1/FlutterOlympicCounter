class Participant {
  String? name;
  int? year;
  int? squadNumber;

  Participant({
     required this.name,
    required this.year,
    required this.squadNumber,
  });

  void displayInfo() {
    print('Name: $name, Year: $year, Squad Number: $squadNumber');
  }
}