import 'package:app/port/app-hierarchy/WeraAppAdmin.dart';
import 'package:app/port/admin/view/SerializableTester.dart';
import 'package:app/port/app-hierarchy/StateWidget.dart';
import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/material.dart';

import 'port/admin/view/AdminChat.dart';
import 'port/admin/view/Steuerung.dart';
import 'port/admin/view/UserRights.dart';
import 'port/app-hierarchy/App.dart';
import 'port/view/Home.dart';
import 'port/view/Lobpreis.dart';
import 'port/view/UserProfile.dart';

void main() {
  List<Widget> _pages = [
    Home(),
    UserProfile(),
    Home(),
    Lobpreis(),
    AdminChat(),
    UserRights(),
    Steuerung(),
    SerializableTester(),
  ];
  runApp(StateWidget(child: WeraAppAdmin(app: App(pages: _pages))));
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

const EVENTS_KEY = "fetch_events";

/// This "Headless Task" is run when app is terminated.
void backgroundFetchHeadlessTask(String taskId) async {
  // API1.requestSSL(null, "GET", "/Songs").then((r) { print(r); });
  print('[BackgroundFetch] Headless event received.');
  BackgroundFetch.finish(taskId);
}