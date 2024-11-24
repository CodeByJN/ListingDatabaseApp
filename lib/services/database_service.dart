import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  Database? _database;

  DatabaseService._internal();

  factory DatabaseService() => _instance;

  // Method to initialize the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        _createTables(db);
      },
    );
  }

  // Method to create database tables
  Future<void> _createTables(Database db) async {
    // Table for car dealerships
    await db.execute('''
      CREATE TABLE dealerships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        zipCode TEXT NOT NULL
      )
    ''');

    // Additional tables for customers, cars, or sales can be added here if required
  }

  // *** CRUD Operations for Dealerships ***

  // Insert a new dealership
  Future<void> insertDealership(Map<String, String> dealership) async {
    final db = await database;
    await db.insert('dealerships', dealership);
  }

  // Update an existing dealership
  Future<void> updateDealership(Map<String, String> dealership) async {
    final db = await database;
    await db.update(
      'dealerships',
      dealership,
      where: 'id = ?',
      whereArgs: [dealership['id']],
    );
  }

  // Delete a dealership
  Future<void> deleteDealership(String id) async {
    final db = await database;
    await db.delete(
      'dealerships',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Get all dealerships
  Future<List<Map<String, String>>> getAllDealerships() async {
    final db = await database;
    final result = await db.query('dealerships');
    return result.map((row) {
      return {
        'id': row['id'].toString(),
        'name': row['name'] as String,
        'address': row['address'] as String,
        'city': row['city'] as String,
        'zipCode': row['zipCode'] as String,
      };
    }).toList();
  }

  // Method to clear all data from the dealerships table (for debugging purposes)
  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('dealerships');
    // Add additional clear operations for other tables if required
  }
}
