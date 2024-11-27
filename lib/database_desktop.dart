import 'package:floor/floor.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'app_database.dart';

Future<AppDatabase> getDatabase() async {
  // Initialize SQLite for desktop platforms
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  return await $FloorAppDatabase.databaseBuilder('app_database.db').build();
}
