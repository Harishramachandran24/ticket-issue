import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ticketform/data/models/ticket.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  return openDatabase(
    join(dbPath, 'tickets.db'),
    version: 1,
    onCreate: (db, version) {
      return db.execute(
        '''CREATE TABLE tickets(
          id TEXT PRIMARY KEY,
          title TEXT,
          description TEXT,
          location TEXT,
          date TEXT,
          attachmentUrl TEXT,
          isSynced INTEGER DEFAULT 0
        )''',
      );
    },
  );
}


  Future<void> addTicket(Ticket ticket) async {
    final db = await database;
    await db.insert('tickets', ticket.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Ticket>> getTickets() async {
    final db = await database;
    final maps = await db.query('tickets');
    return List.generate(maps.length, (i) => Ticket.fromMap(maps[i]));
  }

  Future<void> clearTickets() async {
    final db = await database;
    await db.delete('tickets');
  }

  Future<void> markAsSynced(String ticketId) async {
  final db = await database;
  await db.update(
    'tickets',
    {'isSynced': 1},
    where: 'id = ?',
    whereArgs: [ticketId],
  );
}


  Future<List<Ticket>> getUnsyncedTickets() async {
  final db = await database;
  final maps = await db.query('tickets', where: 'isSynced = ?', whereArgs: [0]);
  return List.generate(maps.length, (i) => Ticket.fromMap(maps[i]));
}

}
                             