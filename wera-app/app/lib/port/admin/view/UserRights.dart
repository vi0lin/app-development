import 'package:app/port/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/Network.dart';
import '../AdminFunctions.dart';
import 'TutorialOverlay.dart';
import '../User.dart';

class UserRightsModel {
   TextEditingController useridController;
}

class _UserRightsData extends InheritedWidget {
  final _UserRightsState data;
  _UserRightsData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_UserRightsData old) => true;
}

class UserRights extends StatefulWidget {

  static _UserRightsState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_UserRightsData>().data;
  }

  @override
  _UserRightsState createState() => _UserRightsState();
}

class _UserRightsState extends State<UserRights> {

  UserRightsModel model;

  @override
  void initState() {
    super.initState();
    if(this.model == null)
      this.model = new UserRightsModel();

    if(this.model.useridController == null)
       this.model.useridController =  TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    // print("------------build!!-----------");
    return buildHomeScreen(context);
  }  

  // void callback() {
  //   setState(() {
  //     print("callback!");
  //   });
  // }

  Future<String> loadUsers(dynamic context) async {
    await AdminFunctions.loadUsers(context).then((r) {
      print(r);
      //setState(() {return "loaded";});
    });
    return "loaded.";
  }

  void _showOverlay(BuildContext context, User user) {
    Navigator.of(context).push(TutorialOverlay(user));
  }

  FutureBuilder<String> _futureBuilder(BuildContext context) {
    return FutureBuilder<String>(
      future: loadUsers(context), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return new Text('None...');
          case ConnectionState.waiting: return buttonList(context);//new Text('Awaiting result...');
          default: 
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return buttonList(context);
              // return new Text('Result: ${snapshot.data}');
        }
      },
    );
  } 

  Widget buttonList(BuildContext context) {
    List<Row> rowList = new List<Row>();
    Column c = Column(children: rowList);
    if(Users.users != null) {
      for (int i = 0; i < Users.users.length; i++) {
        User currentUser = Users.users[i];
        rowList.add(
          Row(
            children: [
              FlatButton(onPressed: () => _showOverlay(context, currentUser), child: Text(Users.users[i].idUser.toString() + " " + Users.users[i].superuser.toString())),
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
      return c;
    }
    else rowList.add(new Row(children: [ new Text("No Users found.")]));
  }

  Widget buildHomeScreen(BuildContext context, {Widget body}) {
    Widget l = _futureBuilder(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('UserRights'),
      ),
      body: Column(
        children: [
          Text("Search All Users - local query via DOWNLOAD or ONLINE query"),
          Container(
            child: Center(
              child: Container(
                //mainAxisAlignment: MainAxisAlignment.center,         
                child: l,
            )),
          ),
        ]
      ),
      bottomNavigationBar: Row(children: [
        FlatButton(onPressed: () { this.loadUsers(context); }, child: Icon(Icons.refresh, semanticLabel: "Reload",),),
        FlatButton(onPressed: () { this.loadUsers(context); }, child: Icon(Icons.sort, semanticLabel: "Sort",),),
        FlatButton(onPressed: () { this.loadUsers(context); }, child: Icon(Icons.search, semanticLabel: "Sort",),),
      ],)
    );
  }
}

/*
new TextField(controller: this.model.useridController),          
new Text('By UserID'),
new FlatButton(
  child: Text("Load"),
  onPressed: () {
    API1.requestSSL("GET", "PERMISSION", null).then((response) {
      print(response.body); 
    });
  }
,)*/