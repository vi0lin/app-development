import 'dart:ui';

import 'DialogHelper.dart';

class AlertException {
  String text;
  int statusCode;
  AlertException(String text, int statusCode, Color color, dynamic context) {
    try {
      this.text = text;
      this.statusCode = statusCode;
      //DialogHelper.httpNotification(context, text, statusCode, color);
      DialogHelper.httpNotificationTop(context, text, statusCode, color);
    }
    catch (e) {
      print("Way to fast. No context found = no Dialog appears. Basta! " + e.toString());
    }
  }
}