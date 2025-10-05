import 'dart:convert';
import 'dart:io';

// import 'package:dio/adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:dio/dio.dart';
import 'package:zoom_widget/zoom_widget.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  debugPrint('Starting bzrk');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.amber),
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 0,
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.circle), text: "Wera Forum"),
                  Tab(icon: Icon(Icons.circle), text: "Kids Forum"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                DefaultTabController(
                  length: 5,
                  child: Scaffold(
                    appBar: AppBar(
                      // toolbarTextStyle: const TextStyle(color: Colors.white),
                      // backgroundColor: Colors.black,
                      // toolbarTextStyle: const TextStyle(color: Colors.white),
                      toolbarHeight: 0,
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: "KG"),
                          Tab(text: "EG"),
                          Tab(text: "ZG"),
                          Tab(text: "1OG"),
                          Tab(text: "2OG"),
                        ],
                      ),
                    ),
                    body: const TabBarView(
                      children: [
                        MyHomePage(title: 'KG'),
                        MyHomePage(image: 'images/WeraForum/eg.png', title: 'EG'),
                        MyHomePage(image: 'images/WeraForum/zg.png', title: 'ZG'),
                        MyHomePage(image: 'images/WeraForum/1og.png', title: '1 OG'),
                        MyHomePage(title: '2 OG'),
                      ],
                    ),
                  ),
                ),
                DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      toolbarHeight: 0,
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: "Garage"),
                          Tab(text: "1OG"),
                          Tab(text: "2OG"),
                        ],
                      ),
                    ),
                    body: const TabBarView(
                      children: [
                        MyHomePage(title: 'Garage'),
                        MyHomePage(image: 'images/KidsForum/1og.png', title: '1 OG'),
                        MyHomePage(image: 'images/KidsForum/2og.png', title: '2 OG'),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.image, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  final String? image;

  Image getImage() {
    if (image != null) {
      return Image(image: AssetImage(image!));
    } else {
      //Füge diesen Link auf der Website ein, auf der deine App zum Download verfügbar ist, oder im Beschreibungsbereich der von dir genutzten Plattformen oder Marktplätze.
      // <div>Icons erstellt von <a href="https://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/de/" title="Flaticon">www.flaticon.com</a></div>
      return const Image(image: AssetImage("images/icons/jesus.png"));
    }
  }

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  WebSocketChannel? ws;
  String? _cookie;
  String? _io;

  init() {
    futureImage();
  }

  // List<String> litems = ["1", "2", "Third", "4"];
  List? data;

  Future<String> loadJsonData() async {
    var jsonText = await rootBundle.loadString('assets/buttons.json');
    setState(() => data = json.decode(jsonText));
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  // // ignore: prefer_typing_uninitialized_variables
  // late var decoded;
  // decodedImage() async {
  //   File file = File(widget.image);
  //   decoded = await decodeImageFromList(file.readAsBytesSync());
  // }

  void _incrementCounter() {
    setState(() {
      debugPrint(widget.getImage().width.toString());
      futureImage();
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> _getConnection() async {
    const addrA = "{API_ADRESS}";
    Map<String, String> body = {'username': '{USERNAME}', 'password': '{PASSWORD}', 'stayloggedin': 'on', 'origin': ''};

    Dio dio = Dio();
    // (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
    //     (HttpClient client) {
    //   client.badCertificateCallback =
    //       (X509Certificate cert, String host, int port) => true;
    //   return client;
    // };

    // https://stackoverflow.com/questions/65630743/how-to-solve-flutter-web-api-cors-error-only-with-dart-code
    // git config --edit --system
    // git config --edit --global

    Map<String, String> headers = {'Access-Control-Allow-Credentials': 'true', 'Access-Control-Allow-Origin': 'http://localhost:59289'};

    try {
      final response = await dio.post(addrA,
          data: body,
          options: Options(
              validateStatus: (status) {
                return status! < 500;
              },
              headers: headers,
              contentType: "application/json"));
      _cookie = response.headers["Set-Cookie"]?[0];
    } finally {
      debugPrint("_cookie ");
      debugPrint(_cookie);
    }

    try {
      const addrB = "{API_SOCKET.IO}";
      final response = await dio.get(addrB,
          options: Options(
              headers: {'Cookie': _cookie},
              validateStatus: (status) {
                return status! < 500;
              },
              contentType: "application/json"));
      //_cookie = response.headers["set-cookie"]?[0];
      String s = response.data;
      String trimmed = s.substring(s.indexOf('{'), s.length);
      debugPrint(trimmed);
      _io = json.decode(trimmed)["sid"];
    } finally {
      debugPrint(_cookie);
      debugPrint(_io);
    }
  }

  // ignore: prefer_typing_uninitialized_variables
  late double? imageWidth = 200;
  // ignore: prefer_typing_uninitialized_variables
  late double? imageHeight = 200;
  // ignore: prefer_typing_uninitialized_variables
  var decodedImage;
  futureImage() async {
    File img = File(widget.image!); // Or any other way to get a File instance.
    decodedImage = await decodeImageFromList(img.readAsBytesSync());
    debugPrint(decodedImage.width.toString());
    debugPrint(decodedImage.height.toString());
    imageWidth = decodedImage.width;
    imageHeight = decodedImage.height;
    // return decodedImage;
  }

  Widget myButton(int index) {
    //return Text(data![index]["action"]);
    return Positioned(
        child: TextButton(
          child: Text(data![index]["action"]),
          onPressed: () {
            debugPrint(data![index]["action"]);
            //ws?.sink.add('4216["setState","mqtt.0.hap.141.122.set","OFF"]');
            //ws?.sink.add('4217["setState","mqtt.0.hap.141.122.status","OFF"]');
          },
        ),
        left: data![index]["left"].toDouble(),
        top: data![index]["top"].toDouble());
  }

  Widget buildBody(BuildContext ctxt, int index) {
    //if (data == null) return const Text("nothing to display");
    return myButton(index);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),
      ),
      body: Zoom(
        backgroundColor: Colors.white,
        initZoom: 0,
        maxZoomWidth: 1024, //imageWidth ?? 1000, //decoded?.width ?? 1000,
        maxZoomHeight: 1024, //imageHeight ?? 1000, //decoded?.height ?? 1000,
        child: Container(
          decoration: BoxDecoration(image: DecorationImage(image: widget.getImage().image)),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Stack(children: <Widget>[data != null ? ListView.builder(itemCount: data?.length, itemBuilder: (BuildContext ctxt, int index) => buildBody(ctxt, index)) : const Text("Nothing to display")]

              // const Positioned(
              //   child: Text("Lorem ipsum"),
              //   left: 200.0,
              //   top: 24.0,
              // ),
              // const Text("Not positioned"),
              ),

          /*
          Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Invoke "debug painting" (press "p" in the console, choose the
            // "Toggle Debug Paint" action from the Flutter Inspector in Android
            // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
            // to see the wireframe for each widget.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              Text(
                '$_counter',
                style: Theme.of(context).textTheme.headline4,
              ),
              TextButton(
                child: const Text('On.'),
                onPressed: () {
                  debugPrint('wss on.');
                  //WS.turnLightOn();
                  ws?.sink.add('4216["setState","mqtt.0.hap.141.122.set","ON"]');
                  ws?.sink.add('4217["setState","mqtt.0.hap.141.122.status","ON"]');
                },
              ),
              TextButton(
                child: const Text('Off.'),
                onPressed: () {
                  debugPrint('wss off.');
                  //WS.turnLightOnOff();
                  ws?.sink.add('4216["setState","mqtt.0.hap.141.122.set","OFF"]');
                  ws?.sink.add('4217["setState","mqtt.0.hap.141.122.status","OFF"]');
                },
              ),
              TextButton(
                child: const Text('auth.'),
                onPressed: () {
                  //WS.auth();
                  _getConnection().then((value) => {
                        setState(() {
                          ws = IOWebSocketChannel.connect(
                            "{API_SOCKET.IO}" + _io!,
                          );

                          // Dio dio = Dio();
                          // (dio.httpClientAdapter as DefaultHttpClientAdapter)
                          //     .onHttpClientCreate = (HttpClient client) {
                          //   client.badCertificateCallback =
                          //       (X509Certificate cert, String host, int port) =>
                          //           true;
                          //   return client;
                          // };

                          ///
                          /// Start listening to new notifications / messages
                          ///
                          // ws!.stream.listen(
                          //   (dynamic message) {
                          //     debugPrint('message $message');
                          //   },
                          //   onDone: () {
                          //     debugPrint('ws channel closed');
                          //   },
                          //   onError: (error) {
                          //     debugPrint('ws error $error');
                          //   },
                          // );
                          // ws = IOWebSocketChannel.connect(
                          //     "{API_SOCKET.IO}" +
                          //         _io!,
                          //     headers: <String, dynamic>{
                          //       "Cookie": _cookie! + "; io=" + _io!,
                          //       "Sec-WebSocket-Version:": "13",
                          //       "Origin:": "{API}",
                          //       "Sec-WebSocket-Extensions:": "permessage-deflate",
                          //       "Sec-WebSocket-Key:": "{API_SEC_WEBSOCKET_KEY}",
                          //       "DNT:": "1",
                          //       "Connection:": "keep-alive, Upgrade",
                          //       "Sec-Fetch-Dest:": "websocket",
                          //       "Sec-Fetch-Mode:": "websocket",
                          //       "Sec-Fetch-Site:": "same-origin",
                          //       "Pragma:": "no-cache",
                          //       "Cache-Control:": "no-cache",
                          //       "Upgrade:": "websocket"
                          //     });

                          ws?.sink.add('2probe');
                          ws?.sink.add('5');
                          ws?.sink.add('420["authenticate"]');
                          ws?.sink.add('421["authEnabled"]');
                          ws?.sink.add('422["getVersion"]');
                          ws?.sink.add('423["authEnabled"]');
                          ws?.sink.add('424["getVersion"]');
                          ws?.sink.add('426["getStates",[]]');
                        })
                      });
                  // http
                  //     .get(Uri(
                  //         host: '{API}',
                  //         path:
                  //             '{API_SOCKET_IO_PATH}'))
                  //     .then((response) => {debugPrint(response.body)});

                  /*
      
                  ws?.sink.add('2probe');
                  ws?.sink.add('5');
                  ws?.sink.add('420["authenticate"]');
                  ws?.sink.add('421["authEnabled"]');
                  ws?.sink.add('422["getVersion"]');
                  ws?.sink.add('423["authEnabled"]');
                  ws?.sink.add('424["getVersion"]');
                  ws?.sink.add('426["getStates",[]]');
                  */
                },
              ),
              const Text("Streams:"),
              ws != null
                  ? StreamBuilder(
                      stream: ws?.stream,
                      builder: (context, snapshot) {
                        return Text(snapshot.hasData ? '${snapshot.data}' : '');
                      },
                    )
                  : const Text('ws not initialized.')
            ],
          ),*/
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
