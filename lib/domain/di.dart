import 'package:get_it/get_it.dart';
import '../domain/services/time_service.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => TimeService());
}
