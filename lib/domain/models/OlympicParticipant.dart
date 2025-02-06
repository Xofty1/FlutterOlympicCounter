import 'package:olympic_counter/domain/models/Participant.dart';

class OlympicParticipant extends Participant {
  int ropeJumping; // Прыжки со скакалкой
  int ballThrowing; // Броски мяча
  int armFlexionExtension; // Сгиб разгиб рук
  int highJump; // Прыжки в высоту
  int longJump; // Прыжки в длину
  int running60m; // Бег 60 м.
  int points = 0;

  OlympicParticipant({
    required super.name,
    required super.year,
    required super.squadNumber,
    required this.ropeJumping,
    required this.ballThrowing,
    required this.armFlexionExtension,
    required this.highJump,
    required this.longJump,
    required this.running60m,
  });
}