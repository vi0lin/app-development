import 'package:flutter/material.dart';

enum REST {
  POST,
  PUT,
  GET,
  DELETE
}

enum Endpoint {
  Users,
  Songs,
  Articles,
  Token,
  Permissions,
  UserPermission,
  SubscribeToNews,
  SendToNews,
  FirebaseMessage,
  Superuser,
  Nodes,
  Node,
  Json,
}

enum WidgetTypeEnum {
  site,
  text,
  image,
  html,
  audio,
  video,
  lobpreis
}

class Config {
  static bool gotTokenForThisSession = false;
  static Key homeKey = ObjectKey("Home");
  static bool local = false;
  static String host = '{WERA_STEUERUNG_API_DOMAIN}';
  static String api2ip() { return 'https://'+host+':9000/'; }
  static String api1ip() { return 'https://'+host+':9777/'; }

  static String localApkVersion = "";
  static String onlineApkVersion = "";
  static bool enableLogin = true;
}
