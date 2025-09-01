import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sms_transaction.dart';

class DatabaseService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'credisense.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  static Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sms_transactions (
        id TEXT PRIMARY KEY,
        sender TEXT NOT NULL,
        message TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL,
        merchant TEXT,
        category TEXT,
        cardNumber TEXT,
        accountNumber TEXT,
        isProcessed INTEGER NOT NULL,
        isUPI INTEGER NOT NULL,
        isCreditCard INTEGER NOT NULL,
        isEMI INTEGER NOT NULL,
        isSalary INTEGER NOT NULL,
        isAutopay INTEGER NOT NULL,
        isBalanceAlert INTEGER NOT NULL,
        isOverdue INTEGER NOT NULL,
        isLateFee INTEGER NOT NULL
      )
    ''');
  }

  static Future<void> insertSMSTransaction(SMSTransaction transaction) async {
    final db = await database;
    await db.insert(
      'sms_transactions',
      {
        'id': transaction.id,
        'sender': transaction.sender,
        'message': transaction.message,
        'timestamp': transaction.timestamp.toIso8601String(),
        'type': transaction.type.toString(),
        'amount': transaction.amount,
        'merchant': transaction.merchant,
        'category': transaction.category,
        'cardNumber': transaction.cardNumber,
        'accountNumber': transaction.accountNumber,
        'isProcessed': transaction.isProcessed ? 1 : 0,
        'isUPI': transaction.isUPI ? 1 : 0,
        'isCreditCard': transaction.isCreditCard ? 1 : 0,
        'isEMI': transaction.isEMI ? 1 : 0,
        'isSalary': transaction.isSalary ? 1 : 0,
        'isAutopay': transaction.isAutopay ? 1 : 0,
        'isBalanceAlert': transaction.isBalanceAlert ? 1 : 0,
        'isOverdue': transaction.isOverdue ? 1 : 0,
        'isLateFee': transaction.isLateFee ? 1 : 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<SMSTransaction>> getSMSTransactions({
    DateTime? since,
    int limit = 1000,
  }) async {
    final db = await database;
    
    String whereClause = '';
    List<dynamic> whereArgs = [];
    
    if (since != null) {
      whereClause = 'WHERE timestamp >= ?';
      whereArgs.add(since.toIso8601String());
    }
    
    final results = await db.query(
      'sms_transactions',
      where: whereClause.isEmpty ? null : whereClause,
      whereArgs: whereArgs.isEmpty ? null : whereArgs,
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return results.map((row) => SMSTransaction(
      id: row['id'] as String,
      sender: row['sender'] as String,
      message: row['message'] as String,
      timestamp: DateTime.parse(row['timestamp'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == row['type'],
        orElse: () => TransactionType.alert,
      ),
      amount: row['amount'] as double?,
      merchant: row['merchant'] as String?,
      category: row['category'] as String?,
      cardNumber: row['cardNumber'] as String?,
      accountNumber: row['accountNumber'] as String?,
      isProcessed: (row['isProcessed'] as int) == 1,
      isUPI: (row['isUPI'] as int) == 1,
      isCreditCard: (row['isCreditCard'] as int) == 1,
      isEMI: (row['isEMI'] as int) == 1,
      isSalary: (row['isSalary'] as int) == 1,
      isAutopay: (row['isAutopay'] as int) == 1,
      isBalanceAlert: (row['isBalanceAlert'] as int) == 1,
      isOverdue: (row['isOverdue'] as int) == 1,
      isLateFee: (row['isLateFee'] as int) == 1,
    )).toList();
  }

  static Future<void> clearAllTransactions() async {
    final db = await database;
    await db.delete('sms_transactions');
  }

  static Future<int> getTransactionCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sms_transactions');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}
