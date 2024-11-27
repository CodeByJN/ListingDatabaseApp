import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// A singleton service to manage database interactions.
/// This service handles all CRUD operations for the app's SQLite database.
class DatabaseService {
  // Singleton instance of the DatabaseService
  static final DatabaseService _instance = DatabaseService._internal();

  // Reference to the database
  Database? _database;

  // Private constructor for singleton
  DatabaseService._internal();

  // Factory constructor to return the same instance
  factory DatabaseService() => _instance;

  /// Provides the database instance, initializing it if necessary.
  Future<Database> get database async {
    // Return the existing database instance if already initialized
    if (_database != null) return _database!;

    // Initialize the database if it hasn't been created yet
    _database = await _initDatabase();
    return _database!;
  }

  /// Private method to initialize the database.
  ///
  /// - Retrieves the database path.
  /// - Sets up the database file (`app_database.db`) with the required tables.
  Future<Database> _initDatabase() async {
    // Get the default database directory
    final dbPath = await getDatabasesPath();

    // Construct the full path for the database file
    final path = join(dbPath, 'app_database.db');

    // Open or create the database
    return openDatabase(
      path,
      version: 1, // Version of the database schema
      onCreate: (db, version) async {
        // Create necessary tables when the database is first created
        await _createTables(db);
      },
    );
  }

  /// Creates all required tables for the database.
  ///
  /// Currently, it sets up a single table `dealerships`.
  ///
  /// - `id`: Primary key (autoincremented).
  /// - `name`: Name of the dealership (required).
  /// - `address`: Street address (required).
  /// - `city`: City of the dealership (required).
  /// - `zipCode`: ZIP code (required).
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE dealerships (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        zipCode TEXT NOT NULL
      )
    ''');
  }

  /// Inserts a new dealership record into the database.
  ///
  /// - [dealership]: A map containing dealership details (name, address, city, zipCode).
  /// - Adds the generated `id` to the input map after successful insertion.
  Future<void> insertDealership(Map<String, String> dealership) async {
    final db = await database;
    try {
      // Insert the record and get the new row's ID
      final id = await db.insert('dealerships', dealership);
      // Add the generated ID back into the map
      dealership['id'] = id.toString();
    } catch (e) {
      throw Exception('Error inserting dealership: $e');
    }
  }

  /// Updates an existing dealership record.
  ///
  /// - [dealership]: A map containing updated dealership details.
  /// - Requires the `id` of the dealership to identify the row to update.
  Future<void> updateDealership(Map<String, String> dealership) async {
    final db = await database;
    try {
      // Update the record where the `id` matches
      await db.update(
        'dealerships',
        dealership,
        where: 'id = ?', // Condition to match the correct row
        whereArgs: [dealership['id']], // Arguments for the condition
      );
    } catch (e) {
      throw Exception('Failed to update dealership: $e');
    }
  }

  /// Deletes a dealership record by its ID.
  ///
  /// - [id]: The unique identifier of the dealership to delete.
  Future<void> deleteDealership(String id) async {
    final db = await database;
    try {
      // Delete the record where the `id` matches
      await db.delete(
        'dealerships',
        where: 'id = ?', // Condition to match the correct row
        whereArgs: [id], // Arguments for the condition
      );
    } catch (e) {
      throw Exception('Failed to delete dealership: $e');
    }
  }

  /// Retrieves all dealership records from the database.
  ///
  /// - Returns a list of maps, where each map represents a dealership record.
  Future<List<Map<String, dynamic>>> getAllDealerships() async {
    final db = await database;
    try {
      // Query all rows from the `dealerships` table
      return await db.query('dealerships');
    } catch (e) {
      throw Exception('Failed to retrieve dealerships: $e');
    }
  }
}
