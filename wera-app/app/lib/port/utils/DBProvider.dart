import 'package:app/port/utils/Network.dart';
import 'package:app/port/utils/config.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';

// class Memento<T> {

// }

class Serializable<T> {

  static List<Map<String, dynamic>> saveAgenda = new List<Map<String, dynamic>>();
  //Serializable getState() {
  //  return states.last;
  //}
  //List<Serializable> states;
  void setMemento() {
    saveAgenda.add(returnSelf().toMap());
    //this.states.add(returnSelf());
  }

  Serializable returnSelf() { return this; }
  int id;
  static String tableName() { return null; }
  Serializable(this.id);
  String toJson() {return null;}
  T fromJson(String json) { return null; }
  // Serializable.fromJson(String json);
  Map<String, dynamic> toMap() {return null;}
  //Serializable.fromMap(Map<String,dynamic> json);
  T fromMap(Map<String,dynamic> json) { return null; }
}

// class Serializable<T> {
//   Serializable returnSelf() { return this; }
//   int id;
//   static String tableName() { return null; }
//   Serializable(this.id);
//   String toJson() {return null;}
//   T fromJson(String json) { return null; }
//   // Serializable.fromJson(String json);
//   Map<String, dynamic> toMap() {return null;}
//   //Serializable.fromMap(Map<String,dynamic> json);
//   T fromMap(Map<String,dynamic> json) { return null; }
// }

// final factories = [
//   <Type, Function>{Serializable: (dynamic x) => Serializable.fromMap(x)},
//   <Type, Function>{Serializable: (dynamic x) => Serializable.fromJson(x)},
//   ];

// T make<T extends Serializable>(dynamic x) {
//   return factories[T](x);
// }

mixin DataClass<T> {
  String createStatement() { return null; }
  String tableName() { return null; }
  List<String> memberNames() { return null; }
  // Map<String, dynamic> toJson() { return null; }
  // T fromJson(String json) { return null; }
  // T fromMap(Map<dynamic, dynamic> json) { return null; }
  //factory IDataClass.fromJson(String source) => IDataClass.fromMap(json.decode(source));
  //factory IDataClass.fromMap(Map<String, dynamic> map) { return null; }
}

mixin DBSProvider<T extends Serializable> on DataClass<T>, Serializable {
  // This is the actual database filename that is saved in the docs directory.
  // static final _databaseName = "app.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;



  // Make this a singleton class.
  // DBSProvider._privateConstructor();
  // static final DBSProvider instance = DBSProvider._privateConstructor();
  // static final DBSProvider instance = new DBSProvider();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null)
      await _onCreate(_database, _databaseVersion);
    return _database;
  }

  dropDatabase() async {
    print("delete Database");
    deleteDatabase("db/app.db");
  }

  // open the database
  initDatabase() async {
    //AssetBundle ab = new AssetBundle();
    //ab.load("db/app.db");
    _database = await openDatabase("db/app.db", version: _databaseVersion, onCreate: _onCreate);
    return _database;

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
    try {
      print(createStatement());
      await db.execute(createStatement());
    }
    catch(e) {
      print("maybe db already exists.");
    }
  }

  Future<int> save() async {
    int cloudId = await saveCloud();
    int localId = await saveLocal();
  }

  Future<int> saveLocal() async {
    Database db = await database;
    returnSelf().setMemento();
    // if(returnSelf().id != null)
    //if(returnSelf().id != null) {
    var a = await load(returnSelf().id);
    if (a == null)
      return db.insert(tableName(), returnSelf().toMap());
    else
      return db.update(tableName(), returnSelf().toMap(), where: memberNames().first+' = ?', whereArgs: [returnSelf().id]);
    //} else {
    //  print("not saved. need to obtain an id from server");
    //}
  }

  Future<int> updateLocal() async {
    Database db = await database;
    String whereString = "";
    List<dynamic> args = new List<dynamic>();
    await load(returnSelf().id).then((value) {
      if(value == null) { // nicht gefunden, also update ich eins, was alles gleich hat, außer die id.
        for(var a in memberNames()) {
          if(memberNames().indexOf(a) == 0) whereString += a + ' is null';
          else whereString += a + ' = ?';
          if(memberNames().indexOf(a) < memberNames().length-1) whereString += ' AND ';
        }
        returnSelf().toMap().forEach((key, value) { if(memberNames().first != key) args.add(value); });
        Map<String, dynamic> clone = returnSelf().toMap();
        // clone[memberNames().first] = null;
        whereString += " AND rowid IN (select rowid from node where "+memberNames().first+" is null limit 1)";
        return db.update(tableName(), clone, where: whereString, whereArgs: args).then((value) {
          return value;
        });
      }
      else {
        saveLocal();
        print("already in local Database - build update logic for other field, too. not only id handling.");
      }
    });
  }

  Future<int> saveCloud() async {
    // Database db = await database;
    // var a = await load(returnSelf().id);
    // if (a == null)
    //   return db.insert(tableName(), returnSelf().toMap());
    // else
    //   return db.update(tableName(), returnSelf().toMap(), where: memberNames().first+' = ?', whereArgs: [returnSelf().id]);
  }
  
  // Database helper methods:

  // Future<int> insert(Serializable entity) async {
  //   Database db = await database;
  //   int id = await db.insert(tableName(), entity.toMap());
  //   return id;
  // }

  Future<int> delete() async {
    Database db = await database;
    int id = await db.delete(tableName(), where: memberNames().first+' = ?', whereArgs: [returnSelf().id]);
    return id;
  }

  // Future<int> deleteAll() async {
  //   Database db = await database;
  //   int id = await db.delete(tableName());
  //   return id;
  // }

  Future<T> load(int id) async {
    if(id != null) {
      Database db = await database;
      List<Map> maps = await db.query(tableName(),
          columns: memberNames(),
          where: memberNames().first+' = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return returnSelf().fromMap(maps.first); //T.fromMap(maps.first);
      }
    }
    return null;
  }

  Future<T> download(int id) async {
    String arg = "";
    if(id != null) arg = id.toString();
    API1.requestSSL(REST.GET, Endpoint.Node, arg).then((value) { return value; } );
  }
  Future<Serializable> upload(int parent) async {
    String arg = "";
    if(parent != null) arg = parent.toString();
    return await API1.requestSSL(REST.PUT, Endpoint.Node, arg, returnSelf().toMap()).then((value) {
      if(value.statusCode == 200) {
        print(value);
        Iterable l = jsonDecode(value.body);
        //ApplicationCache.songs=(l as List).map((i) => Song.fromJson(i)).toList();
        Serializable a = returnSelf().fromMap(l.first);
        return a;
      }
      else { print(value.body); }
    } );
  }

  Future<List<dynamic>> loadAll() async {
    Database db = await database;
    List<Map> maps = await db.query(tableName(), columns: memberNames());
    if (maps.length > 0) {
      var i = maps.map((i) => returnSelf().fromMap(i)/*T.fromJson(i)*/).toList();
      return i;
    }
    return null;
  }

  // Future<List<T>> queryEntities() async {
  //   Database db = await database;
  //   List<Map> maps = await db.query(tableName(),
  //       columns: memberNames(),
  //       );
  //   if (maps.length > 0) {
  //     return maps.map((i) => Serializable.fromJson(i)).toList();
  //   }
  //   return null;
  // }

  // Future<Null> updateEntity(T entity) async {
  //   Database db = await database;
  //   db.update(tableName(), entity.toMap(), where: memberNames().first+' = ?', whereArgs: [entity.id]);
  // }
}