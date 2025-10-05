import 'package:app/port/admin/view/DeveloperMenue.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../LocationProvider.dart';
import '../MenueProvider.dart';
class WeraAppAdmin extends StatefulWidget {

  Widget app;
  WeraAppAdmin({Widget app}) {
    this.app = app;
    int i = 0;
  }

  static _WeraAppAdminState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return context.findAncestorWidgetOfExactType<_MyAppData>().data;
  }

  @override
  _WeraAppAdminState createState() => _WeraAppAdminState();
}

class _MyAppData extends InheritedWidget {
  final _WeraAppAdminState data;
  _MyAppData({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_MyAppData old) => true;
}

class _WeraAppAdminState extends State<WeraAppAdmin> with WidgetsBindingObserver {

  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.NONE,
        startOnBoot: true

    ), (String taskId) async {
      // This is the fetch-event callback.
      // API1.requestSSL(null, "GET", "Songs").then((r) { print(r); });
      print("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
      setState(() {
        _status = status;
      });
    }).catchError((e) {
      print('[BackgroundFetch] configure ERROR: $e');
      setState(() {
        _status = e;
      });
    });

    // Optionally query the current BackgroundFetch status.
    int status = await BackgroundFetch.status;
    setState(() {
      _status = status;
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
      return MaterialApp(
          title: 'Wera App',
          theme: ThemeData(
              primarySwatch: Colors.blue,
          ),
          
          home: LocationProvider(child: MenueProvider(menue: DeveloperMenue(), child: this.widget.app)),
          //Lobpreis(),
          //home: Container(),
      );
  }
}