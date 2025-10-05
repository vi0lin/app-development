import 'dart:async';

import 'package:sqflite/sqflite.dart';

// COMPILE FOR ADMIN ONLY
class Users {
  static User user;
  static List<User> users = new List<User>();
}


final String _table = 'user';
final String _idUser = 'idUser';
final String _uid = 'uid';
final String _decodedToken = 'decodedToken';
final String _idToken = 'idToken';
final String _created = 'created';
final String _modified = 'modified';
final String _superuser = 'superuser';
// final String _lastRecievedPush = 'lastRecievedPush';

class User {
  int idUser;
  String uid;
  String decodedToken;
  String idToken;
  DateTime created;
  DateTime modified;

  bool superuser;
  // DateTime lastRecievedPush;

  User({this.idUser, this.uid, this.decodedToken, this.idToken, this.created, this.modified, this.superuser/*, this.lastRecievedPush*/});

  factory User.fromJson(Map<String, dynamic> json) {
    print(json['superuser']==null?false:true);
    var a = json['lastRecievedPush']==null?null:DateTime.parse(json['lastRecievedPush']);
    return User(
      idUser: json['idUser'],
      uid: json['uid']!=null?json['uid']:"",
      decodedToken: json['decodedToken']!=null?json['decodedToken']:"",
      idToken: json['idToken']!=null?json['idToken']:"",
      created: DateTime.parse(json['created']),
      modified: DateTime.parse(json['modified']),
      superuser: json['superuser']==null?false:true,
      // lastRecievedPush: json['lastRecievedPush']==null?null:DateTime.parse(json['lastRecievedPush'])
    );
  }
  Map<String, dynamic> toJson() => {
  '$_idUser': this.idUser,
  '$_uid': this.uid,
  '$_decodedToken': this.decodedToken,
  '$_idToken': this.idToken,
  '$_created': this.created.toIso8601String(),
  '$_modified': this.modified.toIso8601String(),
  '$_superuser': this.superuser,
  // '$_lastRecievedPush': this.lastRecievedPush.toIso8601String(),
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