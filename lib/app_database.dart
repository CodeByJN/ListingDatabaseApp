import 'package:floor/floor.dart';
import 'car.dart';
import 'car_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Car])
abstract class AppDatabase extends FloorDatabase {
  CarDao get carDao;
}
