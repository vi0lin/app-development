// ignore: avoid_web_libraries_in_flutter
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WS {
  static WebSocketChannel ws = IOWebSocketChannel.connect(
      "{API_SECURE_WEBSOCKET}");

  static close() {
    ws.sink.close();
  }

  static auth() {
    debugPrint("connect");
    // ws.onMessage.listen((MessageEvent e) {
    //   debugPrint(e.data);
    // });
    //ws != null &&
    // if (ws.readyState == WebSocket.OPEN) {
    ws.sink.add('2probe');
    ws.sink.add('5');
    ws.sink.add('420["authenticate"]');
    ws.sink.add('421["authEnabled"]');
    ws.sink.add('422["getVersion"]');
    ws.sink.add('423["authEnabled"]');
    ws.sink.add('424["getVersion"]');
    ws.sink.add('426["getStates",[]]');
    // } else {
    //   // print('WebSocket not connected, message $data not sent');
    //   debugPrint('not connected.');
    // }
  }

  static turnLightOn() {
    ws.sink.add('4216["setState","mqtt.0.hap.141.122.set","ON"]');
    ws.sink.add('4217["setState","mqtt.0.hap.141.122.status","ON"]');
  }

  static turnLightOnOff() {
    ws.sink.add('4216["setState","mqtt.0.hap.141.122.set","OFF"]');
    ws.sink.add('4217["setState","mqtt.0.hap.141.122.status","OFF"]');
  }
}
