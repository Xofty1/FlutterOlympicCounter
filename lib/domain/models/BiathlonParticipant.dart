import 'package:olympic_counter/domain/models/Participant.dart';

class BiathlonParticipant extends Participant {

  int? finishTime;
  int? startTime;
  int? penaltyLoopNumber;
  int? totalTime;

  BiathlonParticipant({required super.name,
    required super.year,
    required super.squadNumber,
    required this.finishTime,
    required this.startTime,
    required this.penaltyLoopNumber,
    required this.totalTime
  });
}
