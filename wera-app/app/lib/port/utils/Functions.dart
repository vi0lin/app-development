import 'dart:convert';
import 'package:app/port/utils/ApplicationCache.dart';
import 'package:app/port/model/Article.dart';
import 'package:app/port/view/Lobpreis.dart';
import 'Network.dart';
import '../model/Permission.dart';
import '../model/Song.dart';
import 'config.dart';

class Functions {
  static Future<List<Article>> loadArticles(dynamic context, [int page=1]) async {
    List<Article> result;
    API1.requestSSL(REST.GET, Endpoint.Articles, page.toString()).then((response) {
      Iterable l = jsonDecode(response.body);
      result=(l as List).map((i) => Article.fromJson(i)).toList();
    });
  }
  static void loadSongs(dynamic context) async {
    try {
      // API1.requestSSL(null, "GET", "/Songs").then((r) { print(r); });
      print(Config.api1ip());
      print(Config.api2ip());
      API1.requestSSL(REST.GET, Endpoint.Songs).then((response) {
        if(response != null) {
          //setState(() {
          //Iterable l = json.decode(response.body);
          Iterable l = jsonDecode(response.body);
          ApplicationCache.songs=(l as List).map((i) => Song.fromJson(i)).toList();
          ApplicationCache.songs.forEach((s) {
            SongProvider.instance.insert(s);
          });
        }
      });
      //_HomeState stateObject = context.findAncestorStateOfType<_HomeState>();
      //stateObject.setState(() {
      LobpreisState stateObject = context.findAncestorStateOfType<LobpreisState>();
      stateObject.setState(() {
        stateObject.model.updateSearchResults(ApplicationCache.songs);
      });
      //Lobpreis.of(context).setState(() {
      //    Lobpreis.of(context).model.updateSearchResults(Songs.songs);
      //});
    } catch(e) {
      print(e);
    }
    
  }
  static Future<void> loadToken() async {
    print("try getting token - gotTokenForThisSession: " + Config.gotTokenForThisSession.toString());
    API1.requestSSL(REST.GET, Endpoint.Token).then((r) {
        if(r != null) {
          var uuid = jsonDecode(r.body);
          if(uuid != null && uuid.isNotEmpty && uuid["uuid"] != null) {
            API2.setSessionCode(uuid["uuid"]);
            Config.gotTokenForThisSession = true;
          }
        } else {
          print("try loading token. maybe server down?");
        }
      });
  }

  static Future<List<Permission>> loadPermissions(dynamic context) async {
    return await API1.requestSSL(REST.GET, Endpoint.Permissions).then((response) {
        Iterable l = jsonDecode(response.body);
        print(response.body);
        List<Permission> list = (l as List).map((i) => Permission.fromJson(i)).toList();
        Permissions.permissions = list;
        return list;
    });    
  }
}