import 'dart:convert';
import 'package:app/port/utils/config.dart';

import '../utils/Network.dart';
import '../model/Permission.dart';
import 'User.dart';

class AdminFunctions {
  static Future<List<User>> loadUsers(dynamic context) async {
    return await API1.requestSSL(REST.GET, Endpoint.Users).then((response) {
        Iterable l = jsonDecode(response.body);
        print(response.body);
        List<User> list = (l as List).map((i) => User.fromJson(i)).toList();
        Users.users = list;
        return list;
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


  static Future<void> addUserPermission(dynamic context, User user, Permission permission) async {
    Map<String, dynamic> data = {"idUser": user.idUser, "idPermission": permission.idPermission};
    return await API1.requestSSL(REST.PUT, Endpoint.UserPermission, null, data).then((response) {
        //Iterable l = jsonDecode(response.body);
        //print(response.body);
        //List<Permission> list = (l as List).map((i) => Permission.fromJson(i)).toList();
        //Permissions.permissions = list;
        //return list;
    });    
  }

  static Future<void> deleteUserPermission(dynamic context, User user, Permission permission) async {
    Map<String, dynamic> a = {"idUser": user.idUser, "idPermission": permission.idPermission};
    return await API1.requestSSL(REST.DELETE, Endpoint.UserPermission, user.idUser.toString()+"/"+permission.idPermission.toString()).then((response) {
        //Iterable l = jsonDecode(response.body);
        //print(response.body);
        //List<Permission> list = (l as List).map((i) => Permission.fromJson(i)).toList();
        //Permissions.permissions = list;
        //return list;
    });    
  }

  static Future<List<Permission>> loadUserPermissions(dynamic context, User user) async {
    return await API1.requestSSL(REST.GET, Endpoint.UserPermission, user.idUser.toString()).then((response) {
        Iterable l = jsonDecode(response.body);
        print(response.body);
        List<Permission> list = (l as List).map((i) => Permission.fromJson(i)).toList();
        return list;
    });
  }
}