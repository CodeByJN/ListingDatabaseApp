import 'package:floor/floor.dart';
import 'app_database.dart';

Future<AppDatabase> getDatabase() async {
  // Regular database initialization for Android/iOS
  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
}
