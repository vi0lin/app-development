import 'package:flutter/material.dart';

import '../app-hierarchy/App.dart';

class HttpNotificationTop {

  String message;
  int statusCode;
  Color color;
  HttpNotificationTop(dynamic context, String message, int statusCode, Color color) {
    this.message = message;
    this.statusCode = statusCode;
    this.color = color;
    App.of(context).showNotification(1234, this.statusCode.toString(), this.message, null);
  }

  _buildChild(BuildContext context) =>
    Container(
      child: Row(children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          // FlatButton(onPressed: (){
          //   Navigator.of(context).pop();
          //   //App.of(context).model.connect(context);
          // }, child: Icon(Icons.close, color: Colors.white)),
          Text(this.statusCode.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(this.message, style: TextStyle(color: Colors.black)),
        ],)
      ]
    ),
  );
}