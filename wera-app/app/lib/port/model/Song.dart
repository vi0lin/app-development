import 'dart:async';

import 'package:app/port/utils/ApplicationCache.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/config.dart';
import 'package:sqflite/sqflite.dart';

class Songs {

  static Song song;

  //deprecated. remoev it soon.
  static Future<List<Song>> loadSongs() async {
    final response = await http.get(Config.api1ip()+'Songs');
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      print(response.body);
      ApplicationCache.songs=(l as List).map((i) => Song.fromJson(i)).toList();
      print(ApplicationCache.songs);
      return ApplicationCache.songs;
    } else {
      throw Exception('Failed to load Songs');
    }
  }
}

final String _table = 'song';
final String _id = 'id';
final String _title = 'title';
final String _text = 'text';
final String _chordsJson = 'chordsJson';
final String _created = 'created';
final String _modified = 'modified';

class ChordsJson {
  List akkorde;
  List zeil;
  List spalte;
}

class Song {
  int id;
  String title;
  String text;
  String chordsJson;
  DateTime created;
  DateTime modified;

  Song({this.id, this.title, this.text, this.chordsJson, this.created, this.modified});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title']!=null?json['title']:"",
      text: json['text']!=null?json['text']:"",
      chordsJson: json['chordsJson']!=null?json['chordsJson']:"",
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
    );
  }
  static Future<Song> fetchSong(int id) async {
    final response = await http.get(Config.api1ip()+'Song/'+id.toString());
    if (response.statusCode == 200) {
      //return new Song();
      return Song.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }
  Map<String, dynamic> toJson() => {
  '$_id': this.id,
  '$_title': this.title,
  '$_text': this.text,
  '$_chordsJson': this.chordsJson,
  '$_created': this.created.toIso8601String(),
  '$_modified': this.modified.toIso8601String(),
  };
}

/* class SongProvider {
  // Only allow a single open connection to the database.
  static Database _db;
  Future<Database> get db async {
    if ( _db != null) return _db;
    _db = await _initDatabase();
    return  _db;
  }

    // This is the actual database filename that is saved in the docs directory.
    static final _databaseName = "app.db";
    // Increment this version when you need to change the schema.
    static final _databaseVersion = 1;

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          create table $_table ( 
          $_id integer null, 
          $_title text null,
          $_text text null,
          $_chordsJson text null,
          $_created DateTime null,
          $_modified DateTime null)
        ''');
  }

  static Future<List<Song>> loadSongs() async {
    open('app.db');
    List<Map<String, dynamic>> records = await db.query();
    close();
    return records.map((i) => Song.fromJson(i)).toList();;
  }

  Future<Null> saveSongs() async {
    Database db = await db;
    Songs.songs.forEach((s) { insert(s);}); //batch..
    close();
  }

        // Make this a singleton class.
  SongProvider._privateConstructor();
  static final SongProvider instance = SongProvider._privateConstructor();

/*   
  static Future open(String path) async {
    db = await openDatabase(
      path, version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          create table $_table ( 
          $_id integer null, 
          $_title text null,
          $_text text null,
          $_chordsJson text null,
          $_created DateTime null,
          $_modified DateTime null)
        ''');
    });
  } */

  Future<Song> insert(Song song) async {
    song.id = await db.insert(_table, song.toJson());
    return song;
  }

  Future<Song> getSong(int id) async {
    List<Map> maps = await db.query(_table,
        columns: [_id, _title, _text, _chordsJson, _created, _modified],
        where: '$_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Song.fromJson(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(_table, where: '$_id = ?', whereArgs: [id]);
  }

  Future<int> update(Song todo) async {
    return await db.update(_table, todo.toJson(),
        where: '$_id = ?', whereArgs: [todo.id]);
  }

  static Future close() async => db.close();
} */


// singleton class to manage the database
class SongProvider {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "app.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  SongProvider._privateConstructor();
  static final SongProvider instance = SongProvider._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    //AssetBundle ab = new AssetBundle();
    //ab.load("db/app.db");
    
    return await openDatabase("db/app.db", version: _databaseVersion, onCreate: _onCreate);

    /*// The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
    */
  }

  // SQL string to create the database 
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      create table $_table ( 
        $_id integer null, 
        $_title text null,
        $_text text null,
        $_chordsJson text null,
        $_created DateTime null,
        $_modified DateTime null
      )
    ''');
  }

  // Database helper methods:

  Future<int> insert(Song song) async {
    Database db = await database;
    int id = await db.insert(_table, song.toJson());
    return id;
  }

  Future<int> deleteAll() async {
    Database db = await database;
    int id = await db.delete(_table);
    return id;
  }

  Future<Song> querySong(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(_table,
        columns: [_id, _title, _text, _chordsJson, _created, _modified],
        where: '$_id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return Song.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Song>> querySongs() async {
    Database db = await database;
    List<Map> maps = await db.query(_table,
        columns: [_id, _title, _text, _chordsJson, _created, _modified],
        );
    if (maps.length > 0) {
      return maps.map((i) => Song.fromJson(i)).toList();
    }
    return null;
  }

  Future<Null> updateSong(Song song) async {
    Database db = await database;
    db.update(_table, song.toJson(), where: '$_id = ?', whereArgs: [song.id]);
  }
}

//adb devices
//adb -s emulator-5554 shell
//run-as com.wera.app
//cd /data/user/0/com.wera.app/databases/db/
//sqlite3 app.db
//.tables
//select * from node;
//select * from song;