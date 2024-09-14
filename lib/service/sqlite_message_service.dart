import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:chatme/model/message.dart';

class SQLiteMessageService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    String path = await getDatabasesPath();
    return await openDatabase(
      join(path, 'chat_messages.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE messages (
            id TEXT PRIMARY KEY,
            senderId TEXT,
            receiverId TEXT,
            content TEXT,
            timestamp INTEGER
          )
        ''');
      },
      version: 1,
    );
  }

  Future<void> insertMessage(Message message) async {
    final Database db = await database;
    await db.insert(
      'messages',
      message.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Message>> getMessages(String userId, String otherUserId) async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where:
          '(senderId = ? AND receiverId = ?) OR (senderId = ? AND receiverId = ?)',
      whereArgs: [userId, otherUserId, otherUserId, userId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) {
      return Message.fromMap(maps[i]);
    });
  }

  Future<void> deleteAllMessages() async {
    final Database db = await database;
    await db.delete('messages');
  }
}
