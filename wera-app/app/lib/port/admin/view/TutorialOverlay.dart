import 'package:app/port/utils/weraStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../utils/Functions.dart';
import '../../model/Permission.dart';
import '../AdminFunctions.dart';
import '../User.dart';

class TutorialOverlayModel {
  List<Permission> permissions = new List<Permission>();
  User user;
}

// class TutorialOverlay extends StatefulWidget {

//   static _TutorialOverlayState of(BuildContext context) {
//     //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
//     return (context.ancestorWidgetOfExactType(_TutorialOverlayData) as _TutorialOverlayData).data;
//   }

//   @override
//   _TutorialOverlayState createState() => _TutorialOverlayState();
// }

// class _TutorialOverlayData extends InheritedWidget {
//   final _TutorialOverlayState data;
//   _TutorialOverlayData({
//     Key key,
//     @required Widget child,
//     @required this.data,
//   }) : super(key: key, child: child);

//   @override
//   bool updateShouldNotify(_TutorialOverlayData old) => true;
// }

// class _TutorialOverlayState extends State<TutorialOverlay> with WidgetsBindingObserver {
//   TutorialOverlayModel model;
//   ModalRoute<void> overlay;

//   @override
//   Widget build(BuildContext context) {
//     return _Overlay(this.model).buildPage(context);
//   }


// }

class TutorialOverlay extends ModalRoute<void> {
  
  TutorialOverlayModel model;

  TutorialOverlay(User user) {
    if(this.model == null) this.model = new TutorialOverlayModel();
    this.model.user = user;
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.935);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      // make sure that the overlay content is not cut off
      child: SafeArea(
        child: _buildOverlayContent(context),
        
      ),
    );
  }

  FutureBuilder<String> _futureBuilder(BuildContext context) {
    return FutureBuilder<String>(
      future: loadUserPermissions(context), // a Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none: return new Text('None...');
          case ConnectionState.waiting: return _permissionList(context);//new Text('Awaiting result...');
          default: 
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            else
              return _permissionList(context);
              // return new Text('Result: ${snapshot.data}');
        }
      },
    );
  } 

  Future<String> loadUserPermissions(BuildContext context) async {
    await Functions.loadPermissions(context);
    await AdminFunctions.loadUserPermissions(context, this.model.user).then((value) {
        this.model.permissions = value;
        // print(value);
        // print("should update now!!");
        setState(() {
          return "inside setState();";
        });
      }
    );
    return "futureistic";
  }
  static const List<String> choices = <String>[
  "Löschen",
  ];
  Future<void> _select2(BuildContext context, Permission permission) async {
      //_selectedChoices = choice;
      await AdminFunctions.addUserPermission(context, this.model.user, permission).then((v){
        this.loadUserPermissions(context);
      });
      //print("select2." + permission.requestEndpoint);
  }
  Future<void> _select(BuildContext context, Permission permission, String choice) async {
    await AdminFunctions.deleteUserPermission(context, this.model.user, permission).then((v){
      this.loadUserPermissions(context);
    });
    //showSnackBar(choice);
    //this.model.permissions[i].idPermission.toString()
  }
  Widget _permissionList(BuildContext context) {
    List<Column> columnList = new List<Column>();
    // print("should it be full?");
    print(this.model.permissions);
    if(this.model.permissions.length > 0) {
      // print("bigger");
      for (int i = 0; i < this.model.permissions.length; i++) {
        Permission permission = this.model.permissions[i];
        print(permission.idPermission);
        columnList.add(
          Column(
            
            children: [
              PopupMenuButton(
                padding: EdgeInsets.only(left: 10.0),
                child: Container(
                  width: 100,
                  child: Column(
                    children: [
                      Icon(Icons.cloud_circle, color: Colors.grey),
                      Text(permission.idPermission.toString(), style: textStyleTextWhiteBig),
                      Text(permission.requestEndpoint.toString(), style: textStyleTextWhiteBig),
                      Text(permission.requestMethod.toString(), style: textStyleTextWhiteBig),
                      Text(permission.requestPath.toString(), style: textStyleTextWhiteBig),
                    ],
                  ),
                ),
                onSelected: (_choice) { setState( () { _select(context, this.model.permissions[i], _choice); }); },
                // initialValue: choices[_selection],
                itemBuilder: (BuildContext context) {
                  return choices.map((String choice) {
                    return  PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
              // FlatButton(onPressed: () => _showOverlay(context, currentUser), child: Text(Users.users[i].idUser.toString() + " " + Users.users[i].superuser.toString())),
              // FlatButton(onPressed: currentUser.superuser==false?(){
              //     API1.requestSSL(context, "PUT", "Superuser/"+Users.users[i].idUser.toString()).then((value) => this.loadUsers(context));
              // }:null, child: Text("Make Superuser.")),
              // FlatButton(onPressed: currentUser.superuser==true?() {
              //     API1.requestSSL(context, "DELETE", "Superuser/"+Users.users[i].idUser.toString()).then((value) => this.loadUsers(context));
              // }:null, child: Text("Remove Superuser.")),
            ]
          )
        );
      }
    }
    columnList.add(
      new Column(
        children: [
          PopupMenuButton(
            padding: EdgeInsets.only(left: 10.0),
            child: Container(
              width: 100,
              child: Column(
                children: [
                  Icon(Icons.add, color: Colors.white)
                ],
              ),
            ),
            onSelected: (_permission) { setState( () { _select2(context, _permission); }); },//_select2,
            // initialValue: choices[_selection],
            itemBuilder: (BuildContext context) {
              return Permissions.permissions.map((Permission permission) {
                return  PopupMenuItem<Permission>(
                  value: permission,
                  child: Text(permission.requestMethod + " " + permission.requestEndpoint + " " + permission.requestPath)
                );
              }).toList();
            },
          )
        ],
      )
    );
    return Row(children: columnList);

  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 30,
            alignment: Alignment.bottomLeft,
            child: FlatButton(
              color: Colors.transparent,
              onPressed: () => Navigator.pop(context),
              child: Icon(Icons.close, size: 53, semanticLabel: "Zurück", color: Colors.white,),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("#"+this.model.user.idUser.toString(), style: TextStyle(color: Colors.white, fontSize: 30.0)),
                Text("Permissions", style: TextStyle(color: Colors.white, fontSize: 30.0)),
              ],
            )
          ),
          _futureBuilder(context),
          FlatButton(onPressed: () { setState(() { this.loadUserPermissions(context); }); }, child: Icon(Icons.refresh, color: Colors.white, semanticLabel: "Reload",)),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
  
  // void initState() {
  //   super.initState();
  //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) { })
    
  // }
}