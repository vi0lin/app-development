import 'package:flutter/material.dart';

class HttpNotificationSnackBar {

  String message;
  int statusCode;
  Color color;
  HttpNotificationSnackBar(dynamic context, String message, int statusCode, Color color) {
    this.message = message;
    this.statusCode = statusCode;
    this.color = color;
    Scaffold.of(context).showSnackBar(snackbar(context));
  }

  SnackBar snackbar(dynamic context) {
    return SnackBar(
      backgroundColor: this.color,
      content: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [_buildChild(context)],
        ),
      ),
    );
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