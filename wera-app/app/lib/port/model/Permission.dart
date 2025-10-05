import 'dart:async';

import 'package:sqflite/sqflite.dart';


// class Users {
//   static User user;
//   static List<User> users = new List<User>();
// }

class Permissions {
  static List<Permission> permissions;
}

final String _table = 'permission';
final String _idPermission = 'idPermission';
final String _requestPath = 'requestPath';
final String _requestMethod = 'requestMethod';
final String _requestEndpoint = 'requestEndpoint';
// final String _lastRecievedPush = 'lastRecievedPush';

class Permission {
  int idPermission;
  String requestPath;
  String requestMethod;
  String requestEndpoint;

  Permission({this.idPermission, this.requestPath, this.requestMethod, this.requestEndpoint});

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      idPermission: json['idPermission'],
      requestPath: json['requestPath'],
      requestMethod: json['requestMethod'],
      requestEndpoint: json['requestEndpoint'],
      // lastRecievedPush: json['lastRecievedPush']==null?null:DateTime.parse(json['lastRecievedPush'])
    );
  }
  Map<String, dynamic> toJson() => {
  '$_idPermission': this.idPermission,
  '$_requestPath': this.requestPath,
  '$_requestMethod': this.requestMethod,
  '$_requestEndpoint': this.requestEndpoint,
  };
}

// // singleton class to manage the database
// class UserProvider {

//   // This is the actual database filename that is saved in the docs directory.
//   static final _databaseName = "app.db";
//   // Increment this version when you need to change the schema.
//   static final _databaseVersion = 1;

//   // Make this a singleton class.
//   UserProvider._privateConstructor();
//   static final UserProvider instance = UserProvider._privateConstructor();

//   // Only allow a single open connection to the database.
//   static Database _database;
//   Future<Database> get database async {
//     if (_database != null) return _database;
//     _database = await _initDatabase();
//     return _database;
//   }

//   // open the database
//   _initDatabase() async {
//     //AssetBundle ab = new AssetBundle();
//     //ab.load("db/app.db");
    
//     return await openDatabase("db/app.db", version: _databaseVersion, onCreate: _onCreate);

//     /*// The path_provider plugin gets the right directory for Android or iOS.
//     Directory documentsDirectory = await getApplicationDocumentsDirectory();
//     String path = join(documentsDirectory.path, _databaseName);
//     // Open the database. Can also add an onUpdate callback parameter.
//     return await openDatabase(path,
//         version: _databaseVersion,
//         onCreate: _onCreate);
//     */
//   }

//   // SQL string to create the database 
//   Future _onCreate(Database db, int version) async {
//     await db.execute('''
//       create table $_table ( 
//         $_id integer null, 
//         $_title text null,
//         $_text text null,
//         $_chordsJson text null,
//         $_created DateTime null,
//         $_modified DateTime null
//       )
//     ''');
//   }

//   // Database helper methods:

//   Future<int> insert(UserProvider user) async {
//     Database db = await database;
//     int id = await db.insert(_table, user.toJson());
//     return id;
//   }

//   Future<int> deleteAll() async {
//     Database db = await database;
//     int id = await db.delete(_table);
//     return id;
//   }

//   Future<User> querySong(int id) async {
//     Database db = await database;
//     List<Map> maps = await db.query(_table,
//         columns: [_id, _title, _text, _chordsJson, _created, _modified],
//         where: '$_id = ?',
//         whereArgs: [id]);
//     if (maps.length > 0) {
//       return User.fromJson(maps.first);
//     }
//     return null;
//   }

//   Future<List<User>> querySongs() async {
//     Database db = await database;
//     List<Map> maps = await db.query(_table,
//         columns: [_id, _title, _text, _chordsJson, _created, _modified],
//         );
//     if (maps.length > 0) {
//       return maps.map((i) => User.fromJson(i)).toList();
//     }
//     return null;
//   }

//   Future<Null> updateSong(User song) async {
//     Database db = await database;
//     db.update(_table, song.toJson(), where: '$_id = ?', whereArgs: [song.id]);
//   }

//   // TODO: queryAllWords()
//   // TODO: delete(int id)
//   // TODO: update(Word word)
// }