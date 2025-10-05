import 'package:flutter/material.dart';

class HttpNotificationDialog extends StatelessWidget {

  String message;
  int statusCode;
  Color color;
  HttpNotificationDialog(String message, int statusCode, Color color) {
    this.message = message;
    this.statusCode = statusCode;
    this.color = color;
  }

  @override
  SimpleDialog build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [_buildChild(context)],
          ),
        ),
      ],
    );
  }

  _buildChild(BuildContext context) => Container(
    height: 50,
    decoration: BoxDecoration(
      color: this.color,
      shape: BoxShape.rectangle,
    ),
    child: Row(children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
          //App.of(context).model.connect(context);
        }, child: Icon(Icons.close)),
        Padding(padding: const EdgeInsets.only(right: 10, left: 10), child: Text(this.statusCode.toString(), style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
        Padding(padding: const EdgeInsets.only(right: 10, left: 10), child: Text(this.message, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)),
      ],)
    ],),
  );
}