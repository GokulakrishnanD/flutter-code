import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:thiran_tech_task/Models/transaction.dart';

class TransactionRepository {
  Database? _database;

  Future<void> initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'transactions.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE transactions(id INTEGER PRIMARY KEY, desc TEXT, status TEXT, dateTime TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    if (_database == null) await initDatabase();
    final List<Map<String, dynamic>> maps =
        await _database!.query('transactions');
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  /// ✅ **Fix: Add this function to fetch only error transactions**
  Future<List<TransactionModel>> getErrorTransactions() async {
    if (_database == null) await initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'transactions',
      where: "status = ?",
      whereArgs: ["Error"],
    );
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }
}
