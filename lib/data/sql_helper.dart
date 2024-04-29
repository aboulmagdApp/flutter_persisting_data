import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import '../models/note.dart';

class SqlHelper {
  final String colId = 'id';
  final String colName = 'name';
  final String colDate = 'date';
  final String colNote = 'note';
  final String colPosition = 'position';
  final String tableNotes = 'notes';

  static Database? _db;
  final int _version = 1;
  static final SqlHelper _singleton = SqlHelper._internal();

  SqlHelper._internal();

  factory SqlHelper() {
    return _singleton;
  }

  Future init() async {
    return _db ??= await _openDb();
  }

  Future _openDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String dbPath = join(dir.path, 'notesAppData.db');
    _db = await openDatabase(dbPath, version: _version, onCreate: _createDb);
    return _db;
  }

  Future _createDb(Database db, int version) async {
    String query =
        'CREATE TABLE $tableNotes ($colId INTEGER PRIMARY KEY, $colName TEXT, $colDate TEXT, $colNote TEXT, $colPosition INTEGER)';
    await db.execute(query);
  }

  Future<int> insertNote(Note note) async {
    //note.position = await findPosition();
    int result = await _db!.insert(tableNotes, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    int result = await _db!.update(tableNotes, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(Note note) async {
    int result = await _db!
        .delete(tableNotes, where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<List<Note>> getNotes() async {
    await init();
    if (_db == null) {
      //print('Database is null, unable to fetch notes');
      return [];
    }

    try {
      List<Map<String, dynamic>> notesList =
          await _db!.query(tableNotes, orderBy: colPosition);
      List<Note> notes = [];
      for (var element in notesList) {
        notes.add(Note.fromMap(element));
      }
      return notes;
    } catch (e) {
      //print('Error fetching notes: $e');
      return [];
    }
  }

  // Future<int> findPosition() async {
  //   final String sql = 'select max($colPosition) from $tableNotes';
  //   List<Map> queryResult = await _db.rawQuery(sql);
  //   int position = queryResult.first.values.first;
  //   position = (position == null) ? 0 : position++;
  //   return position;
  // }

  // Future updatePositions(bool increment, int start, int end) async {
  //   String sql;
  //   if (increment) {
  //     sql =
  //         'update $tableNotes set $colPosition = $colPosition + 1  where $colPosition >= $start and $colPosition <= $end';
  //   } else {
  //     sql =
  //         'update $tableNotes set $colPosition = $colPosition - 1  where $colPosition >= $start and $colPosition <= $end';
  //   }
  //   await _db.rawUpdate(sql);
  // }
}
