import 'dart:convert';

import 'package:app/port/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Network.dart';
import '../../app-hierarchy/StateWidget.dart';
import '../AdminFunctions.dart';
import '../User.dart';

class SteuerungModel {
   TextEditingController useridController;
}

class _SteuerungData extends InheritedWidget {
  final _SteuerungState data;
  _SteuerungData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_SteuerungData old) => true;
}

class Steuerung extends StatefulWidget {

  static _SteuerungState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_SteuerungData>().data;
  }

  @override
  _SteuerungState createState() => _SteuerungState();
}

class _SteuerungState extends State<Steuerung> {

  SteuerungModel model;

  @override
  void initState() {
    super.initState();
    if(this.model == null)
      this.model = new SteuerungModel();

    if(this.model.useridController == null)
       this.model.useridController =  TextEditingController();
       
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    print("------------build!!-----------");
    return buildHomeScreen(context);
  }  

  void callback() {
    setState(() {
      print("callback!");
    });
  }

  Future<void> loadUsers(dynamic context) async {
    print("two superuser: "+Users.users.first.superuser.toString());
    AdminFunctions.loadUsers(context).then((r) {
      print("three superuser: "+Users.users.first.superuser.toString());
      setState(() {});
    });
  }

  List<Widget> buttonList(BuildContext context) {
    print("build superuser: "+Users.users.first.superuser.toString());
    List<Row> rowList = new List<Row>();
    for (int i = 0; i < Users.users.length; i++) {
      User currentUser = Users.users[i];
      rowList.add(
        Row(
          children: [
            Text(Users.users[i].idUser.toString()),
            Text(Users.users[i].superuser.toString()),
            FlatButton(onPressed: currentUser.superuser==false?(){
                API1.requestSSL(REST.PUT, Endpoint.Superuser, Users.users[i].idUser.toString()).then((value) => this.loadUsers(context));
            }:null, child: Text("Make Superuser.")),
            FlatButton(onPressed: currentUser.superuser==true?() {
                API1.requestSSL(REST.DELETE, Endpoint.Superuser, Users.users[i].idUser.toString()).then((value) => this.loadUsers(context));
            }:null, child: Text("Remove Superuser.")),
          ]
        )
      );
    }
    return rowList;
  }

  Widget buildHomeScreen(BuildContext context, {Widget body}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('Steuerung'),
      ),
      body: Container(
        child: Center(
          child: Text("Licht Steuerung"),
        ),
      ),
      bottomNavigationBar: FlatButton(onPressed: () { this.loadUsers(context); }, child: Icon(Icons.refresh, semanticLabel: "Reload",),),
    );
  }
}