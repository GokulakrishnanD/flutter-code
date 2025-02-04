import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:thiran_tech_task/Models/ticket.dart';

class DatabaseHelper {
  static Database? _database;
  static const String dbName = 'tickets.db';

  // Create the database if it doesn't exist
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tickets(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, location TEXT, date TEXT, attachmentUrl TEXT, status TEXT, createdBy TEXT)',
        );
      },
      version: 1,
    );
  }

  // Insert ticket into the database
  Future<void> insertTicket(Ticket ticket) async {
    final db = await database;
    await db.insert(
      'tickets',
      ticket.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Fetch all tickets
  Future<List<Ticket>> getTickets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tickets');

    return List.generate(maps.length, (i) {
      return Ticket.fromMap(maps[i]);
    });
  }
}
