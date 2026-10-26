import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DatabaseService {
  DatabaseService._();
  static final instance = DatabaseService._();
  Database? _db;
  Future<Database> get db async => _db ??= await openDatabase(join(await getDatabasesPath(), 'daily_planner.db'), version: 1, onCreate: (d, _) async {
    await d.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT NOT NULL, text TEXT NOT NULL, color INTEGER NOT NULL, time_minutes INTEGER, status INTEGER, repeat_daily INTEGER NOT NULL DEFAULT 0, created_at INTEGER NOT NULL)');
  });
  Future<List<DailyTask>> tasksFor(String date) async { final d = await db; final rows = await d.query('tasks', where: 'date = ?', whereArgs: [date], orderBy: 'created_at ASC'); return rows.map(DailyTask.fromMap).toList(); }
  Future<int> insert(DailyTask task) async => (await db).insert('tasks', task.toMap()..remove('id'));
  Future<void> update(DailyTask task) async => (await db).update('tasks', task.toMap()..remove('id'), where: 'id = ?', whereArgs: [task.id]);
  Future<void> delete(int id) async => (await db).delete('tasks', where: 'id = ?', whereArgs: [id]);
  Future<bool> hasDate(String date) async => Sqflite.firstIntValue(await (await db).rawQuery('SELECT COUNT(*) FROM tasks WHERE date = ?', [date]))! > 0;
  Future<List<DailyTask>> recurringBefore(String date) async {
    final rows = await (await db).query('tasks', where: 'repeat_daily = 1 AND date < ?', whereArgs: [date], orderBy: 'date DESC, created_at DESC');
    final seen = <String>{};
    return rows.map(DailyTask.fromMap).where((t) => seen.add(t.text.trim())).toList();
  }
}
