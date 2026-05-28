import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import '../models/diary_entry.dart';
import '../utils/date_utils.dart';
import 'database_service.dart';

class DiaryService {
  static final DiaryService instance = DiaryService._();
  DiaryService._();

  Future<Database> get _db => DatabaseService.instance.database;

  Future<DiaryEntry?> getEntryByDate(DateTime date) async {
    final db = await _db;
    final rows = await db.query(
      'diary_entries',
      where: 'date = ?',
      whereArgs: [dateKey(date)],
    );
    return rows.isEmpty ? null : DiaryEntry.fromMap(rows.first);
  }

  Future<List<DiaryEntry>> getAllEntries() async {
    final db = await _db;
    final rows = await db.query('diary_entries', orderBy: 'date DESC');
    return rows.map(DiaryEntry.fromMap).toList();
  }

  Future<DiaryEntry> upsertEntry(DiaryEntry entry) async {
    final db = await _db;
    await db.insert(
      'diary_entries',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    final saved = await getEntryByDate(entry.date);
    return saved!;
  }

  Future<void> deleteEntry(int id) async {
    final db = await _db;
    await db.delete('diary_entries', where: 'id = ?', whereArgs: [id]);
  }
}

final diaryServiceProvider = Provider<DiaryService>((ref) {
  return DiaryService.instance;
});
