// import 'package:app/port/Dialogs/HttpNotificationDialog.dart';
import 'package:app/port/Dialogs/HttpNotificationSnackBar.dart';
import 'package:app/port/Dialogs/HttpNotificationTop.dart';
import 'package:app/port/Dialogs/InvitationConfirmationDialog.dart';
import 'package:app/port/Dialogs/RecievedConfirmationDialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static gotInvitation(context) => showDialog(context: context, builder: (context) => InvitationConfirmationDialog());
  static recievedMessage(context, String caption, String text, String button1, String button2) => showDialog(context: context, builder: (context) => RecievedConfirmationDialog(caption, text, button1, button2));
  //static httpNotification(context, String caption, int statusCode, Color color) => Navigator.of(context).push(PageRouteBuilder(pageBuilder: (context, _, __) => AlertDialog(Text("Title!")),opaque: false),);
  //static httpNotification(context, String caption, int statusCode, Color color) => showDialog(barrierDismissible: false, barrierColor: Colors.white, context: context, builder: (context) => HttpNotificationDialog(caption, statusCode, color));
  static httpNotification(context, String caption, int statusCode, Color color) { HttpNotificationSnackBar(context, caption, statusCode, color); }
  static httpNotificationTop(context, String caption, int statusCode, Color color) { HttpNotificationTop(context, caption, statusCode, color); }
}