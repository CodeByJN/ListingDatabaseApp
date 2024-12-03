import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Customerdatabase {
  static final Customerdatabase _instance = Customerdatabase._internal();
  Database? _database;

  Customerdatabase._internal();

  factory Customerdatabase() => _instance;

  Future<Database> get database async {
    try {
      if (_database != null) {
        print('Returning existing database instance');
        return _database!;
      }
      print('Initializing new database instance');
      _database = await _initDatabase();
      return _database!;
    } catch (e) {
      print('Error getting database: $e');
      rethrow;
    }
  }

  Future<void> _ensureDatabaseDirectoryExists() async {
    try {
      final dbPath = await getDatabasesPath();
      print('Database path: $dbPath');
    } catch (e) {
      print('Error ensuring database directory exists: $e');
      rethrow;
    }
  }

  Future<Database> _initDatabase() async {
    try {
      await _ensureDatabaseDirectoryExists();

      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'app_database.db');

      print('Attempting to open database at: $path');

      // For testing: Delete existing database
      try {
        await deleteDatabase(path);
        print('Deleted existing database');
      } catch (e) {
        print('Error deleting database (this is ok if it didn\'t exist): $e');
      }

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          print('Creating new database...');
          await _createTables(db);
        },
        onOpen: (db) async {
          print('Database opened successfully');
          await _verifyTables(db);
        },
      );
    } catch (e) {
      print('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _verifyTables(Database db) async {
    try {
      final tables = await db.query(
        'sqlite_master',
        where: 'type = ?',
        whereArgs: ['table'],
      );

      print('Existing tables: ${tables.map((t) => t['name']).toList()}');

      if (!tables.any((table) => table['name'] == 'customers')) {
        print('Customers table not found, creating it...');
        await _createTables(db);
      }
    } catch (e) {
      print('Error verifying tables: $e');
      rethrow;
    }
  }

  Future<void> _createTables(Database db) async {
    try {
      await db.transaction((txn) async {
        // Create dealerships table
        print('Creating dealerships table...');
        await txn.execute('''
          CREATE TABLE IF NOT EXISTS dealerships (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            address TEXT NOT NULL,
            city TEXT NOT NULL,
            zipCode TEXT NOT NULL
          )
        ''');

        // Create customers table
        print('Creating customers table...');
        await txn.execute('''
          CREATE TABLE IF NOT EXISTS customers (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            firstName TEXT NOT NULL,
            lastName TEXT NOT NULL,
            address TEXT NOT NULL,
            birthday TEXT NOT NULL
          )
        ''');
      });

      print('Tables created successfully');
    } catch (e) {
      print('Error creating tables: $e');
      rethrow;
    }
  }

  // Modified CRUD operations with error handling
  Future<void> insertCustomer(Map<String, String> customer) async {
    try {
      final db = await database;
      print('Inserting customer: $customer');
      await db.insert('customers', customer);
      print('Customer inserted successfully');
    } catch (e) {
      print('Error inserting customer: $e');
      rethrow;
    }
  }

  Future<List<Map<String, String>>> getAllCustomers() async {
    try {
      final db = await database;
      print('Fetching all customers...');
      final result = await db.query('customers');
      print('Found ${result.length} customers');
      return result.map((row) {
        return {
          'id': row['id'].toString(),
          'firstName': row['firstName'] as String,
          'lastName': row['lastName'] as String,
          'address': row['address'] as String,
          'birthday': row['birthday'] as String,
        };
      }).toList();
    } catch (e) {
      print('Error getting customers: $e');
      rethrow;
    }
  }

  Future<void> updateCustomer(Map<String, String> customer) async {
    try {
      final db = await database;
      print('Updating customer: $customer');
      await db.update(
        'customers',
        customer,
        where: 'id = ?',
        whereArgs: [customer['id']],
      );
      print('Customer updated successfully');
    } catch (e) {
      print('Error updating customer: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      final db = await database;
      print('Deleting customer with id: $id');
      await db.delete(
        'customers',
        where: 'id = ?',
        whereArgs: [id],
      );
      print('Customer deleted successfully');
    } catch (e) {
      print('Error deleting customer: $e');
      rethrow;
    }
  }
}