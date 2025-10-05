import 'dart:async';
import 'package:app/port/admin/User.dart';
import 'package:app/port/view/Home.dart';
import 'package:app/port/view/Lobpreis.dart';
import 'package:app/port/view/UserProfile.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../MenueProvider.dart';
import '../utils/Network.dart';

import '../utils/Functions.dart';
import '../utils/weraStyle.dart';
import 'dart:io' as io;

class App extends StatefulWidget {

  List<Widget> pages;
  App({List<Widget> pages}) {
    this.pages = pages;
    if(pages == null) {
      this.pages = new List.empty();
    }
  }
  static AppState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_AppData>().data;
    //return (context.ancestorWidgetOfExactType(_AppData) as _AppData).data;
  }

  @override
  AppState createState() => AppState();
}

class AppModel {
  API2 api2;

  bool isAdmin = false;
  Scaffold scaffold;

  TextEditingController _consoleOutput;

  print(String text) {
    print(text);
    _consoleOutput.text += text;
  }
  getText() {
    return "_consoleOutput.text: " + _consoleOutput.text;
  }
  connect(dynamic context, {Function(String) callback}) async {
    if(api2 != null) api2.shutdown();
    api2 = new API2();
    await api2.pushStream(context, callback: callback);
  }
  addPush(String push) {
    api2.pushstreams.add(push);
  }
}

class _AppData extends InheritedWidget {
  final AppState data;
  _AppData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_AppData old) => true;
}

class AppState extends State<App> with WidgetsBindingObserver /* with SingleTickerProviderStateMixin */ {

  int _currentIndex = 0;
  PageController pageController;
  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  bool pushStreamEnabled = true;

  FirebaseMessaging _firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  /*color: Colors.grey[800],fontWeight: FontWeight.bold,*/

  AppModel model;

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    // if(ApplicationCache.songs == null)
    //   SongProvider.instance.querySongs().then((list) {
    //     ApplicationCache.songs = list;
    //   });
    return paddingTop(context);
  }

  void setPage(Type type) {
    setState(() {
      //context.findAncestorWidgetOfExactType<App>().
      int index = this.widget.pages.indexWhere((element) => element.runtimeType == type );
      pageController.jumpToPage(index);
      //context.findAncestorWidgetOfExactType<LocationProvider>().page = page;
    });
  }
  // void setPage(Widget page) {
  //   setState(() {
  //     context.findAncestorWidgetOfExactType<LocationProvider>().page = page;
  //   });
  // }
  // void setPageIndex(int index) {
  //   setState(() {
  //     _currentIndex = index;
  //     pageController.jumpToPage(index);
  //     //context.findAncestorWidgetOfExactType<LocationProvider>().page = page;
  //   });

  @override
  void didUpdateWidget(App oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    
  }
  //@override
  //void dispose() {
    // Don't forget to dispose all of your controllers!
    //this.model._text.dispose();
    //this.model._textfield.dispose();
    //this.model.controller.dispose();
    //super.dispose();
  //}

  Future<void> showNotification(
    int notificationId,
    String notificationTitle,
    String notificationContent,
    String payload, {
    String channelId = '1234',
    String channelTitle = 'Android Channel',
    String channelDescription = 'Default Android Channel for notifications',
    Priority notificationPriority = Priority.high,
    Importance notificationImportance = Importance.max,
  }) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      channelId,
      channelTitle,
      channelDescription,
      playSound: false,
      importance: notificationImportance,
      priority: notificationPriority,
    );
    var iOSPlatformChannelSpecifics =
        new IOSNotificationDetails(presentSound: false);
    var platformChannelSpecifics = new NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      notificationTitle,
      notificationContent,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<dynamic> onSelectNotification(String payload) async {
    /*Do whatever you want to do on notification click. In this case, I'll show an alert dialog*/
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(payload),
        content: Text("Payload: $payload"),
      ),
    );
  }

  @override
  void initState() {

    if(flutterLocalNotificationsPlugin == null) {
      var initializationSettingsAndroid = new AndroidInitializationSettings('@mipmap/ic_launcher');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);

      if(_firebaseMessaging == null) {
        _firebaseMessaging = FirebaseMessaging();
        _firebaseMessaging.configure(
          onMessage: (Map<String, dynamic> message) async {
              //print("Message $message");
              //???json.encode(message)
              try {
                print("try");
                print(message["notification"]["title"]);
                print(message["notification"]["body"]);
              } catch(e) {
                print("error");
              }
              showNotification(1234, message["notification"]["title"], message["notification"]["body"], message["notification"]["data"]);
              return;
          }
        );
      }
    }

    Functions.loadToken();
    /*if(Users.users.isEmpty) {
      Functions.loadUsers(null).then((r) {
        Users.users = r;
        setState(() {});
      });
    }*/

    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);
    if(this.model == null)
      this.model = new AppModel();

    // if(context.findAncestorWidgetOfExactType<LocationProvider>().page == null)
    //   context.findAncestorWidgetOfExactType<LocationProvider>().page = Home();
    
    if(this.model._consoleOutput == null)
      this.model._consoleOutput = TextEditingController();
    pushStreamEnabled = true;

    if(this.pageController == null) {
      this.pageController = PageController();
    }
  }

  @override
  void dispose() {
    this.model._consoleOutput.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
    });
  }

  Widget together(BuildContext context) {   
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //header(context),
          Expanded(
            flex: 1,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 50),
              /* transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(child: child, scale: animation), */
              child: PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: this.widget.pages,
              ),
            )
          ),      
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(child: FlatButton(child: Column(children: <Widget>[ Icon(Icons.home, semanticLabel: "Home",), Text("Home", style: textStyleSmall) ]), onPressed: () { setPage(User); /* setState(() { setPage(Home());}); */ },)),
              Expanded(child: FlatButton(child: Column(children: <Widget>[ Icon(Icons.insert_comment, semanticLabel: "Nachrichten",), Text("Nachrichten", style: textStyleSmall) ]), onPressed: () { pageController.jumpToPage(1); /*setState(() { setPage(UserProfile());}); */ },)),
              Expanded(child: FlatButton(child: Column(children: <Widget>[ Icon(Icons.calendar_today, semanticLabel: "Kalender",), Text("Kalender", style: textStyleSmall) ]), onPressed: () {setState(() { pageController.jumpToPage(2); /* setPage(Home()); */ });},)),
              Expanded(child: FlatButton(child: Column(children: <Widget>[ Icon(Icons.headset, semanticLabel: "PODCAST",), Text("PODCAST", style: textStyleSmall) ]), onPressed: () {setState(() { pageController.jumpToPage(3); /* setPage(Lobpreis()); */ });},)),
            ]
          )
        ]
    );
  }

  void callBack(text) {
    setState() {
      this.model.print(text);
    }
  }

  Widget paddingTop(BuildContext context) {
    Scaffold scaff;
    Widget appbar = PreferredSize(
      child: Padding(
        padding: EdgeInsets.only(top: 30),
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Row(
                    children: <Widget>[
                       Icon(
                        Icons.menu,
                        color: Colors.black,
                      )
                    ],
                  )
                ),
                Expanded(child: Image.asset('img/wera-logo-big.png',)),
                Expanded(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Icon(
                        Icons.equalizer,
                        color: Colors.black,
                      ),
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      )
                    ],
                  )
                ),
              ],
            ),
          )
        ), preferredSize: Size(0,50),
    );
    scaff = Scaffold(
      appBar: appbar,
      drawer: Container(width: 140, child: Drawer(child: Container(color: weralightBlack, child: userMenue(context)))),
      /*endDrawer: context.findAncestorWidgetOfExactType<MenueProvider>().menue,*/
      body: GestureDetector(
        onTap: () { FocusScope.of(context).requestFocus(new FocusNode()); },
        child: together(context),
      )
    );
    return scaff;
  }

  Widget header(context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            new Image.asset(
              'img/wera-logo-big.png',
            ),
          ]
        ,)
      ],
    );
  }

  /*Widget _myListView(BuildContext context) {
    return ListView.builder(
      itemCount: ,
      itemBuilder: (BuildContext context, int index) {
        
        
        return flat;
      },
    );
  }*/

  Widget userMenue(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(height:30),
        Row(
          children: <Widget>[
            //new Image.asset(
            //  'img/wera-logo-big-white.png',
            //),
            //Expanded(flex: 1, child: Text("<", textAlign: TextAlign.center, style: textStyleTextWhite)),
            //Expanded(flex: 1, child: Text("Kalender", textAlign: TextAlign.center, style: textStyleTextWhite)),
            //Expanded(flex: 1, child: Text(">", textAlign: TextAlign.center, style: textStyleTextWhite)),
          ],
        ),
        //LoginScreen(),
        FlatButton(child: Text("Home", style: textStyleLightGray), onPressed: () { setState( () {  setPage(Home); Navigator.pop(context); }); } ,),
        FlatButton(child: Text("Das Christentum", style: textStyleLightGray), onPressed: () { setState( () {  setPage(UserProfile); Navigator.pop(context); }); } ,),
        FlatButton(child: Text("Lobpreis", style: textStyleLightGray), onPressed: () { setState( () {  setPage(Lobpreis); Navigator.pop(context); }); } ,),
        
      ],
    );
}

  void startServiceInPlatform() async {
    if(io.Platform.isAndroid) {
      var methodChannel = MethodChannel("com.wera.app");
      String data = await methodChannel.invokeMethod("startService");
      print(data);
    }
  }

  bool initialized = false;

  Timer timer;

  //void _listener() {
  //  print("okay.");
  //}

  //ScrollController _scroller1;
  //ScrollController _scroller2;
}
