import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

import 'package:sqlite_notes_app/models/notes_model.dart';

class DBHandler {
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationCacheDirectory();
    String path = join(documentDirectory.path, 'notes.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  //creating the table in database
  _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT NOT NULL, email TEXT NOT NULL)",
    );
  }

  //insert the items in database
  Future<NotesModel> insert(NotesModel notesModel) async {
    var dbClient = await db;
    await dbClient.insert('notes', notesModel.toMap());
    return notesModel;
  }

  //fetching the list of items from database
  Future<List<NotesModel>> getNotesList() async {
    var dbClient = await db;
    final List<Map<String, dynamic>> queryResult =
        await dbClient.query('notes');

    return queryResult.map((e) => NotesModel.fromMap(e)).toList();
  }

  //deleting the whole table
  Future deleteTableContent() async {
    var dbClient = await db;
    return await dbClient.delete('notes');
  }

  //deleting the particular items at a particular index
  Future<int> deleteItem(int id) async {
    var dbClient = await db;
    return dbClient.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  //updating the database table
  Future<int> updateItems(NotesModel notesModel) async {
    var dbClient = await db;
    return await dbClient.update('notes', notesModel.toMap(),
        where: 'id = ?', whereArgs: [notesModel.id]);
  }

  //closing the database
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
