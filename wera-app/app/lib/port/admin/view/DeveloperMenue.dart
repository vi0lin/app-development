import 'package:app/port/admin/view/SerializableTester.dart';
import 'package:app/port/app-hierarchy/App.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../LocationProvider.dart';
import '../../utils/Functions.dart';
import '../../utils/Network.dart';
import '../../model/Song.dart';
import '../../app-hierarchy/StateWidget.dart';
import '../../utils/config.dart';
import '../../utils/weraStyle.dart';
import '../AdminFunctions.dart';
import 'dart:io' as io;
import 'AdminChat.dart';
import 'Steuerung.dart';
import 'UserRights.dart';

class DeveloperMenueModel {
  TextEditingController _consoleOutput;
  print(String text) {
    print(text);
    _consoleOutput.text += text;
  }
  getText() {
    return "_consoleOutput.text: " + _consoleOutput.text;
  }
}

class DeveloperMenue extends StatefulWidget {
  static _DeveloperMenueState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_DeveloperMenueData>().data;
  }

  @override
  _DeveloperMenueState createState() => _DeveloperMenueState();

  // @override
  // _DeveloperMenueState createState() => _DeveloperMenueState();
}

class _DeveloperMenueData extends InheritedWidget {
  final _DeveloperMenueState data;
  _DeveloperMenueData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_DeveloperMenueData old) => true;
}

class _DeveloperMenueState extends State<DeveloperMenue> with WidgetsBindingObserver{

  TextEditingController _consoleOutput;

  DeveloperMenueModel model;
  
  @override
  void initState() {
    if(this.model == null)
      this.model = new DeveloperMenueModel();
    
    if(this.model._consoleOutput == null)
      this.model._consoleOutput = TextEditingController();
  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget noButton = FlatButton(
      child: Text("Nein"),
      onPressed:  () {
        Config.enableLogin = false;
        print(Config.enableLogin);
        Navigator.of(context, rootNavigator: true).pop();
        },
    );
    Widget yesButton = FlatButton(
      child: Text("Ja"),
      onPressed:  () {
        Config.enableLogin = true;
        print(Config.enableLogin);
        Navigator.of(context, rootNavigator: true).pop();
        StateWidget.of(context).initUser();
        },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Connect to Google?"),
      content: Text("Möchten Sie sich mit Ihrem Google Konto anmelden?"),
      actions: [
        noButton,
        yesButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget developerMenue(BuildContext context) {
    
    // List<Widget> x;
    // Widget a;
    // if(!initialized) {
    //   x.add(new FlatButton(child: Text("add..."), onPressed: () { setState(() { x.add(a); }); }));
    //   initialized = true;
    // }

    // a = new Row(children: [ Text("1"), Text("2"), new FlatButton(child: Text("Remove"), onPressed: () { setState(() {  x.remove(a); }); },), ]);
    // x.add(a);
    // x.add(Text("..."));
    // x.add(Text("..."));
    // Widget w = new Column(children: x );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(height:30),
          // w,
          FlatButton(child: Text("Serializable Tester", style: textStyleLightGray), onPressed: () { context.findAncestorStateOfType<AppState>().setPage(SerializableTester); /* setPage(UserRights()); Navigator.pop(context); */ } ,),//color: weraLightyellow,
          FlatButton(child: Text("Userrights", style: textStyleLightGray), onPressed: () { context.findAncestorStateOfType<AppState>().setPage(UserRights); /* setPage(UserRights()); Navigator.pop(context); */ } ,),//color: weraLightyellow,
          FlatButton(child: Text("Steuerung 3", style: textStyleLightGray), onPressed: () { context.findAncestorStateOfType<AppState>().setPage(Steuerung);/* setPage(Steuerung()); Navigator.pop(context); */ } ,),//color: weraLightyellow,
          FlatButton(child: Text("Admin Chat", style: textStyleLightGray), onPressed: () { context.findAncestorStateOfType<AppState>().setPage(AdminChat); } ,),
          //FlatButton(child: Text("Push Messages", style: textStyleLightGray), onPressed: () { setState(() { this.page = PushMessagingExample(); Navigator.pop(context); }); } ,),//color: weraLightyellow,
          FlatButton(color: weraLightyellow,child: Text("Load Songs (API1)", style: textStyleLight),
            onPressed: () { Functions.loadSongs(context); },
          ),
          FlatButton(color: weraLightyellow,child: Text("Subscribe to News", style: textStyleLight),
            onPressed: () { 
              API1.requestSSL(REST.POST, Endpoint.SubscribeToNews).then((value) {
                print(value);
              });
             },
          ),
          FlatButton(color: weraLightyellow,child: Text("Send to News", style: textStyleLight),
            onPressed: () { 
              API1.requestSSL(REST.POST, Endpoint.SendToNews).then((value) {
                print(value);
              });
             },
          ),
          FlatButton(color: weraLightyellow,child: Text("Firebase Cloud Message", style: textStyleLight),
            onPressed: () { 
              API1.requestSSL(REST.POST, Endpoint.FirebaseMessage).then((value) {
                print(value);
              });
             },
          ),
          FlatButton(color: weraLightyellow,
            child: Text("Connect Admin (API2)",
            style: textStyleLight),
            onPressed: () {
              //this.model.connect does not work here anymore!
              //this.model.connect(context);
              
              //this.model.connect(context);
              // StateWidget.of(context).state.user.getIdToken().then((token) {
              //   print(token);
              //   API2.pushStream(context);
              // });
            }
          ),
          FlatButton(color: weraLightyellow,
            child: Text("Get Users (API1)",
            style: textStyleLight),
            onPressed: () { AdminFunctions.loadUsers(context); },
          ),
          // FlatButton(color: weraLightyellow,
          //   child: Text("SendTcpRenewal (API1)",
          //   style: textStyleLight),
          //   onPressed: () {
          //     timer = Timer.periodic(Duration(seconds: 10), (Timer t) => API1.requestSSL(context, "POST", "Tcp", null).then((response) {
          //       print("TcpRenewal send... " + response.body);
          //       // final completer = Completer<String>();
          //       // final contents = StringBuffer();
          //       // response.transform(utf8.decoder).listen((data) {
          //       //   contents.write(data);
          //       // }, onDone: () => completer.complete(contents.toString()));
          //       // completer.future.then((a)    { print(a); });
          //         // DialogHelper.gotInvitation(context);
          //     }));
              
          //     //API2.sendTcpRenewal(context);

          //     //this.model.connect(context);
          //     // StateWidget.of(context).state.user.getIdToken().then((token) {
          //     //   print(token);
          //     //   API2.pushStream(context);
          //     // });
          //   }
          // ),
          
          FlatButton(color: weraLightyellow,
            child: Text("start Service (Android)",
            style: textStyleLight),
            onPressed: true?null:() {
              startServiceInPlatform();
            }
          ),
          FlatButton(color: weraLightyellow,
            child: Text("change Login behaviour",
            style: textStyleLight),
            onPressed: true?null:() {
              showAlertDialog(context);
            }
          ),
          //Calendar(),
          FlatButton(color: weraLightyellow,child: Text("shop.wera-medien.de", style: textStyleLight), onPressed: true?null:() {} ,),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  FlatButton(color: weraLightyellow,
                    child: Column(
                      children: <Widget>[
                        Text("Check", style: textStyleLight),
                        Text("local: "+Config.localApkVersion, style: textStyleLightsmall),
                        Text("online: "+Config.onlineApkVersion, style: textStyleLightsmall),
                      ],),
                      onPressed: true?null:() {
                        //APK.gatherHead("{WERA_PROJECTS_DOMAIN}:8000/app.apk").then( (r) {
                        //  setState( () {
                        //    this.model.online_apk_date = r.entries.firstWhere( (t) { return t.key=="date"; } ).value;
                        //  });
                        //});
                        /*APK.gatherInfo().then( (r) {
                          setState ( () {
                            localApkVersion = r.versionName;
                          } );
                          APK.getOnlineVersion().then( (r) { 
                            setState ( () {
                              onlineApkVersion = r;
                            });
                          });
                        });*/
                      }
                  ),
                  FlatButton(
                    color: weraLightyellow,
                    child: new Text("Get latest", style: textStyleLight),
                    onPressed: true?null:() { APK.downloadFile("{WERA_PROJECTS_DOMAIN}:8000/app.apk", (cb) { setState( () { downloadStatus = cb; }); } ,filename: "app.apk"); },
                  ),
                ]
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: downloadStatus,
                child:Container( color: weraYellow, height: 3),
              ),
            ]
          ),
          FlatButton(color: weraLightyellow,
            child: Text("Logout",
            style: textStyleLight),
            onPressed: () {
              setState(() {
                try {
                  StateWidget.of(context).signOut();
                } catch (e) {
                  print("logout failed."+e.toString());
                }
              });  
            }
          ),
          FlatButton(color: weraLightyellow,child: Text("Create Demo Song", style: textStyleLight),
            onPressed: true?null:() {
              setState(() {
                Songs.song = new Song(id: 1, title: "Title", text: "Text", chordsJson: "chordsJson", created: DateTime.now(), modified: DateTime.now());
              });
            },
          ),
          FlatButton(color: weraLightyellow,
            child: Text("Clear Songs.songs & sqlite",
            style: textStyleLight),
            onPressed: () {
              setState(() {
                SongProvider.instance.deleteAll();
              });  
            }
          ),
          TextField(
            controller: this.model._consoleOutput,
            obscureText: false,
            decoration: InputDecoration(border: OutlineInputBorder(), labelText:'Console')
          ),
          FlatButton(color: weraLightyellow,
            child: Text("Send to API2",
            style: textStyleLight),
            onPressed: () {
              print(this.model.getText());
              App.of(context).model.addPush(new Push(created: DateTime.now(), idPush: 12, text: this.model.getText()).toJson().toString());
              // StateWidget.of(context).state.user.getIdToken().then((token) {
              //   print(token);
              //   API2.pushStream(context);
              // });
            }
          ),
          Row(
            children: [
              Text("Local"),
              Checkbox(
                value: Config.local,
                onChanged: (value) {
                  setState( () {
                    if (Config.local) {
                      Config.local = false;
                      Config.host = "{SOME_PUBLIC_IP}";
                    }
                    else {
                      Config.local = true;
                      Config.host = "{SOME_PUBLIC_IP}";
                    }

                  });
                }
              ),
            ]
          ),
          Row(
            children: [
              Text("Impersonate User"),
              Checkbox(
                value: impersonateUser,
                onChanged: (value) {
                  setState( () { impersonateUser = value; });
                }
              ),
            ]
          ),
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: 240, child: Drawer(child: Container(color: weralightBlack, child: developerMenue(context))));
    //throw developerMenue(context);
  }
  void startServiceInPlatform() async {
    if(io.Platform.isAndroid) {
      var methodChannel = MethodChannel("com.wera.app");
      String data = await methodChannel.invokeMethod("startService");
      print(data);
    }
  }

}
