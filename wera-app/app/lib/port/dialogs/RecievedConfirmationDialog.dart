import 'package:flutter/material.dart';

import '../app-hierarchy/App.dart';

class RecievedConfirmationDialog extends StatelessWidget {

  String caption;
  String text;
  String button1;
  String button2;
  RecievedConfirmationDialog(String caption, String text, String button1, String button2) {
    this.caption = caption;
    this.text = text;
    this.button1 = button1;
    this.button2 = button2;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
    height: 380,
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(children: [
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
        ),
        child: Padding(padding: const EdgeInsets.all(12), child: Image.asset('img/wera-logo-big.png', height: 128, width: 128)),
        width: double.infinity,
      ),
      SizedBox(height: 22),
      Padding(padding: const EdgeInsets.only(right: 10, left: 10), child: Text(this.caption, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold))),
      SizedBox(height: 8),
      Padding(padding: const EdgeInsets.only(right: 10, left: 10), child: Text(this.text, style: TextStyle(color: Colors.white), textAlign: TextAlign.center,)),
      SizedBox(height:22),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        FlatButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text(this.button2), textColor: Colors.white,),
        SizedBox(width:22),
        FlatButton(onPressed: (){
            App.of(context).model.connect(context);
        }, child: Text(this.button1), color: Colors.white, textColor: Colors.blueAccent),
      ],)
    ],),
  );
}