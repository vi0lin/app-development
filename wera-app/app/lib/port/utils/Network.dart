import 'dart:convert';
import 'dart:math';
import 'package:app/port/model/WidgetType.dart';
import 'package:app/port/utils/Functions.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Dialogs/AlertException.dart';
import '../Dialogs/DialogHelper.dart';
import '../app-hierarchy/StateWidget.dart';
import 'config.dart';
import '../../generated/api2.pbgrpc.dart';
import 'dart:async';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:enum_to_string/enum_to_string.dart';

double downloadStatus = 0.0;

class Vector {
  ResponseStream<PushResponse> x;
  StreamSubscription<PushResponse> y;
  StreamController<String> z;
  Timer t;
  Vector({this.x, this.y, this.z, this.t});
  void kill() async {
    t?.cancel();
    await x.cancel();
    await Future.wait([y.cancel(), z.close()]);
  }
}

class API2 {

  Completer<bool> receivedThree;
  ClientChannel channel;
  ResponseStream<PushResponse> call;
  StreamSubscription<PushResponse> sub;

  void shutdown() {
    // pushstreams.close();
    // if(channel != null) {
    //   channel.terminate();
    //   channel.shutdown();
    // }
    // if(call != null) {
    //   call.cancel();
    // }
    // if(sub != null) {
    //   sub.cancel();
    // }
    if(receivedThree != null) {
      receivedThree.complete(true);
    }
  }
  // ~API2() {
  //   if (channel != null) {
  //     channel.terminate();
  //     channel.shutdown();
  //   }
  // }

  
  final pushstreams = StreamController<String>();

  static Future<void> biDirectional(dynamic context) async {
    FirebaseUser firebaseUser = StateWidget.of(context).state.user;
    final channel = ClientChannel(
    Config.host,
    port: 9001,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
    );
    final stub = API2Client(channel);
    final numbers = StreamController<String>();

    IdTokenResult result = await firebaseUser.getIdToken(refresh: true);
    final name = result.token;
    Stream<Request> stream = numbers.stream.map((value) => Request()..requestData = value);
    final call = stub.bidirectionalStream(stream);
    final receivedThree = Completer<bool>();
    final sub = call.listen((number) {
      if (number.responseData == "quit") {
        receivedThree.complete(true);
      }
    }, onError: (e) => print('Caught: $e'));
    numbers.add(name);
    numbers.add(name);
    numbers.add(name);
    numbers.add(name);
    await receivedThree.future;
    await call.cancel();
    await Future.wait([sub.cancel(), numbers.close()]);
  }

  static Future<void> getCurrentIpAddress() async {
    // NetworkInterface.list(includeLoopback: true, type: InternetAddressType.any)
    //   .then((List<NetworkInterface> interfaces) {
    //     print(interfaces);
    //     interfaces.forEach((interface) {
    //       // _networkInterface += "### name: ${interface.name}\n";
    //       if (interface.name == "wlan") {
    //         host = interface.addresses[0].address;
    //         ip = 'http://'+host+':9000/';
    //       }
    //       // int i = 0;
    //       // interface.addresses.forEach((address) {
    //       //   _networkInterface += "${i++}) ${address.address}\n";
    //       // });
    //     });
    //   });
    // host = await GetIp.ipAddress;
    // ip = 'http://'+host+':9000/';
  }
  static void heartBeat(StreamController<String> pushstreams) {
    pushstreams.add(new Push(created: DateTime.now(), idPush: 12, text: "<3").toJson().toString());
    print("sending <3");
  }

static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
static Random _rnd = Random();
static String sessionCode = "";
static String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  static Future<String> getFileData(String path) async {
    return await rootBundle.loadString(path);
  }

  static List<Vector> mythbuster = new List<Vector>();

  static Timer timer;

  static Future<String> getFirebaseToken(FirebaseUser firebaseUser) async {
    IdTokenResult result = await firebaseUser.getIdToken(refresh: true);
    return result.token;
  }

  static Future<String> getSessionCode() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionCode = prefs.getString('sessionCode') ?? null;
    // if(sessionCode == null)
    //   prefs.setString('sessionCode', API2.getRandomString(256));
    // API2.sessionCode = sessionCode;
    return sessionCode;
  }
  static Future<String> setSessionCode(String uuid) async {
    final prefs = await SharedPreferences.getInstance();
    // final sessionCode = prefs.getString('sessionCode') ?? null;
    // if(sessionCode == null)
    prefs.setString('sessionCode', uuid);
    // API2.sessionCode = sessionCode;
    return sessionCode;
  }

  static Future<String> getToken(FirebaseUser firebaseUser) async {
    if(Config.enableLogin && firebaseUser != null) {
      IdTokenResult result = await firebaseUser.getIdToken(refresh: true);
      return result.token;
    }
    else {
      final prefs = await SharedPreferences.getInstance();
      final sessionCode = prefs.getString('sessionCode') ?? null;
      if(sessionCode == null)
        prefs.setString('sessionCode', API2.getRandomString(256));
      API2.sessionCode = sessionCode;
      return sessionCode;
    }
  }

  static Future<String> getFCMToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    return await _firebaseMessaging.getToken().then((token){
      return token;
    });
  }
  static Future<String> getRegistrationToken() async {
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    return await _firebaseMessaging.getToken().then((token){
      return token;
    });
  }
  // static Future sendTcpRenewal(dynamic context) async {
  //   FirebaseUser firebaseUser = StateWidget.of(context).state.user;
  //   IdTokenResult firebaseToken;
  //   String token = await getToken(firebaseUser, firebaseToken);


  //   String path = "cert.pem";
  //   final byteData = await rootBundle.load("wera-app-api/src/$path");
  //   final file = File('${(await getTemporaryDirectory()).path}/$path');
  //   await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   SecurityContext clientContext = new SecurityContext()..setTrustedCertificates(file.path);
  //   var client = new HttpClient(context: clientContext);
  //   var request = await client.getUrl(Uri.parse("https://"+host+":10777"));
  //   var response = await request.close();
  //   return response;
  //   //   // var server = await HttpServer.bind(
  //   //   //   InternetAddress.loopbackIPv4,
  //   //   //   10777,
  //   //   // );
  //   //   //print('Listening on localhost:${server.port}');

  //   //   // await for (HttpRequest request in server) {
  //   //   //   request.response.write('Hello, world!');
  //   //   //   await request.response.close();
  //   //   // }
  //   // // Map jsonData = {
  //   // //   'idToken': token,
  //   // // };
  //   // // HttpClientRequest request = await HttpClient().post(host, 10777, "/") /*1*/
  //   // //   //..headers.contentType = ContentType.json /*2*/
  //   // //   ..write(jsonEncode(jsonData)); /*3*/
  //   // // HttpClientResponse response = await request.close(); /*4*/
  //   // // await utf8.decoder.bind(response /*5*/).forEach(print);
  //   // http.Response response;
  //   // String target = 'https://'+host+":10777";
  //   // Map<String, dynamic> mybody = {};

  //   // Map<String, String> headers = {
  //   //   'Content-type' : 'application/json', 
  //   //   'Accept': 'application/json',
  //   // };

  //   // mybody = {"idtoken": token};

  //   // // if(data != null)
  //   // //   if (data.isNotEmpty) {
  //   // //     mybody.addAll(data);
  //   // //   }

  //   // // bool trustSelfSigned = true;
  //   // // HttpClient httpClient = new HttpClient()
  //   // //   ..badCertificateCallback =
  //   // //       ((X509Certificate cert, String host, int port) => trustSelfSigned);
  //   // // IOClient ioClient = new IOClient(httpClient);
  //   // // ioClient.post(url, body:data);  

  //   // var f = File('test/resources/rfc5280_cert1.cer');
  //   // var bytes = f.readAsBytesSync(); // this is the byte array
    


  //   // String path = "cert.pem";
  //   // final byteData = await rootBundle.load("wera-app-api/src/$path");
  //   // final file = File('${(await getTemporaryDirectory()).path}/$path');
  //   // await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  //   // final clientCert2 = File('${(await getTemporaryDirectory()).path}/$path').readAsBytesSync();
  //   // //var c = X509Certificate.fromAsn1(ASN1Parser(clientCert2).nextObject());
  //   // X509Certificate x509cert = 

  //   // String encoded = jsonEncode(mybody);

  //   // response = await http.post(target, body: encoded, headers: headers);
  //   // return response;
  // }

  Future<void> pushStream(dynamic context, {Function(String) callback}) async {
    if(channel != null) {
      channel.terminate();
       channel.shutdown();
    }
    print("pushstream...");
    // mythbuster.last.t.cancel();
    // mythbuster.clear();
    // getCurrentIpAddress();
    FirebaseUser firebaseUser = StateWidget.of(context).state.user;
    //callback("Test"); // App.of(context).model.print("Test");
    //Directory documentsDirectory = await getApplicationDocumentsDirectory();
    //String path = join(documentsDirectory.path, "wera-app-api/src/chain.pem");
    String path = "cert.pem";

    final byteData = await rootBundle.load("wera-app-api/src/$path");
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    // final caCert = await rootBundle.load("wera-app-api/src/ca.crt");
    // final caCertFile = File('${(await getTemporaryDirectory()).path}/ca.crt');
    // await caCertFile.writeAsBytes(caCert.buffer.asUint8List(caCert.offsetInBytes, caCert.lengthInBytes));

    // final clientCert = await rootBundle.load("wera-app-api/src/client.crt");
    // final clientCertFile = File('${(await getTemporaryDirectory()).path}/client.crt');
    // await clientCertFile.writeAsBytes(clientCert.buffer.asUint8List(clientCert.offsetInBytes, clientCert.lengthInBytes));

    // final clientKey = await rootBundle.load("wera-app-api/src/client.key");
    // final clientKeyFile = File('${(await getTemporaryDirectory()).path}/client.key');
    // await clientKeyFile.writeAsBytes(clientKey.buffer.asUint8List(clientKey.offsetInBytes, clientKey.lengthInBytes));

    // final serverCert = await rootBundle.load("wera-app-api/src/server.crt");
    // final serverCertFile = File('${(await getTemporaryDirectory()).path}/server.crt');
    // await serverCertFile.writeAsBytes(serverCert.buffer.asUint8List(serverCert.offsetInBytes, serverCert.lengthInBytes));

    //var ssl = new SslCredentials(cacert, new KeyCertificatePair(clientcert, clientkey));
    //channel = new Channel("localhost", 555, ssl);
    //client = new GrpcTest.GrpcTestClient(channel);
    // });
    
    //final trustedRoot = File('${(await getTemporaryDirectory()).path}/$path').readAsBytesSync();
    //final caCertRoot = File('${(await getTemporaryDirectory()).path}/$path').readAsBytesSync();
    //final clientCertRoot = File('${(await getTemporaryDirectory()).path}/$path').readAsBytesSync();
    final clientCert2 = File('${(await getTemporaryDirectory()).path}/cert.pem').readAsBytesSync();
    // String trustedRoot = await getFileData("wera-app-api/src/chain.pem");
    // final trustedRoot = new File("wera-app-api/src/chain.pem").readAsBytesSync();
    final channelCredentials = new ChannelCredentials.secure(certificates: clientCert2);//, authority: "{SOME_PUBLIC_IP}"

    // X509CertificateData cert = X509Utils.x509CertificateFromPem(trustedRoot.toString());
    // X509Certificate ce = new X509Certificate(rawData: byteData, password: '', keyStoreFlags: null);
    // allowBadCertificates(X509Certificate.fromAsn1(ASN1Parser(trustedRoot).nextObject()), '{SOME_PUBLIC_IP}');

    final channelOptions = new ChannelOptions(credentials: channelCredentials);
    channel = ClientChannel(
    Config.host,
    port: 9000,
    options: channelOptions
    );
    final stub = API2Client(channel);

    IdTokenResult firebaseToken;
    String token = await API2.getSessionCode();
    

    PushRequest convert(value) {
      PushRequest pr = new PushRequest();
      pr.message  = value;
      pr.idToken = token;
      return pr;
    }
    Stream<PushRequest> stream = pushstreams.stream.map((value) => convert(value) );

    call = stub.pushStream(stream);
    receivedThree = Completer<bool>();

    // App.of(context).model.print("pushstream triggered");
    // print("pushstream triggered");
    sub = call.listen((number) {

      String out = 'Received: ${number.message}';
      // print(out);
      DialogHelper.recievedMessage(context, "Message Recieved", out, "Close", "Thankx <3");
      // print(out);
      // App.of(context).setState(() {
      //   App.of(context).model.print(out);
      //   print(out);
      // });
      if (number.message == "quit") {
        receivedThree.complete(true);
      }
    }, onError: (e) => print('Caught: $e'));
    pushstreams.add(new Push(created: DateTime.now(), text: API2.sessionCode).toJson().toString());
    //pushstreams.add(new Push(created: DateTime.now(), text: "Test").toJson().toString());
    //pushstreams.add(new Push(created: DateTime.now(), text: "Test3").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test2").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test6").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test6").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test7").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test7").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "Test7").toJson().toString());
    // pushstreams.add(new Push(created: DateTime.now(), text: "quit").toJson().toString());

    //if(timer != null) timer.cancel();
    //timer = Timer.periodic(Duration(seconds: 10), (Timer t) => heartBeat(pushstreams));
    //mythbuster.add(new Vector(x: call, y: sub, z: pushstreams, t: timer));


    await receivedThree.future;
    await call.cancel();
    await Future.wait([sub.cancel(), pushstreams.close()]);
  }
}

final String _table = 'push';
final String _id = 'id';
final String _text = 'text';
final String _created = 'created';

class Push {
  int idPush;
  String text;
  DateTime created;

  Push({this.idPush, this.text, this.created});

  factory Push.fromJson(Map<String, dynamic> json) {
    return Push(
      idPush: json['id'],
      text: json['text']!=null?json['text']:"",
      created: DateTime.parse(json['created']),
    );
  }
  Map<String, dynamic> toJson() => {
  '$_id': this.idPush,
  '$_text': this.text,
  '$_created': this.created.toIso8601String(),
  };
}

class API1 {

  static Future<List<String>> getDeviceDetails() async {
      String deviceName;
      String deviceVersion;
      String identifier;
      final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
      try {
        if (Platform.isAndroid) {
          var build = await deviceInfoPlugin.androidInfo;
          deviceName = build.model;
          deviceVersion = build.version.toString();
          identifier = build.androidId;  //UUID for Android
        } else if (Platform.isIOS) {
          var data = await deviceInfoPlugin.iosInfo;
          deviceName = data.name;
          deviceVersion = data.systemVersion;
          identifier = data.identifierForVendor;  //UUID for iOS
        }
      } on PlatformException {
        print('Failed to get platform version');
      }

  //if (!mounted) return;
  return [deviceName, deviceVersion, identifier];
  }

  static bool _certificateCheck(X509Certificate cert, String host, int port) => true;

  static http.Client sslClient() {
    HttpClient ioClient = new HttpClient()..badCertificateCallback = _certificateCheck;
    return new IOClient(ioClient);
  }
  static Future<Map<String, dynamic>> requestNode({WidgetType widgetType, int id}) {
    String arg;
    if(id != null)
      arg = "id/"+id.toString();
    else if(widgetType != null)
      arg = "widgetType/"+widgetType.idWidgetType.toString();
    // Map<String, dynamic> data = { "id": id, "nodeType": nodeType.index };
    return API1.requestSSL(REST.GET, Endpoint.Json, arg).then((r) {
      // Map<String, dynamic> map;
      // Iterable l = jsonDecode(r.body);
      // print(r.body);
      // map=(l as List).map((i) => Song.fromJson(i)).toList();
      return jsonDecode(r.body);
    });
  }
  static Future<http.Response> requestSSL(REST method, Endpoint endpoint, [ String arguments, Map<String, dynamic> data = const {} ] ) async {
    if (endpoint != Endpoint.Token && !Config.gotTokenForThisSession)
      await Functions.loadToken();
    String firebaseToken;
    String methodString = EnumToString.convertToString(method);
    String endpointString = EnumToString.convertToString(endpoint);
    String idToken = await API2.getSessionCode();
    if(arguments != null && arguments.isNotEmpty)
      arguments = "/"+arguments;
    FirebaseAuth auth = FirebaseAuth.instance;
    // if(user == null && context != null) {
    //   user = StateWidget.of(context).state.user;
    // } else if(user == null && context == null) {
    // }
    FirebaseUser user = await auth.currentUser();  
    if (user != null) firebaseToken = await API2.getFirebaseToken(user);
    
    String fcmToken = await API2.getFCMToken();
    String registrationToken = await API2.getRegistrationToken();
    List<String> deviceDetails = await getDeviceDetails();
    Map<String, String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
      'idToken': idToken,
      'firebaseToken': firebaseToken,
      'fcmToken': fcmToken,
      'deviceName': deviceDetails[0],
      'deviceVersion': deviceDetails[1],
      'identifier': deviceDetails[2]
    };
    http.Response response;
    String arg = "";
    if(arguments!=null) {
      arg = arguments;
    }
    switch(methodString) {
      case "PATCH":
        response = await sslClient().patch(Config.api1ip()+endpointString, headers: headers, body: json.encode(data));
        break;
      case "POST":
        response = await sslClient().post(Config.api1ip()+endpointString, headers: headers, body: json.encode(data));
        break;
      case "PUT":
        response = await sslClient().put(Config.api1ip()+endpointString+arg, headers: headers, body: json.encode(data));
        break;
      case "GET":
        response = await sslClient().get(Config.api1ip()+endpointString+arg, headers: headers);
        break;
      case "DELETE":
        response = await sslClient().delete(Config.api1ip()+endpointString, headers: headers);
        break;
      case "HEAD":
        break;
      case "READ":
        break;
      case "READBYTES":
        break;
    };

    
    //print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    // if(response.statusCode == 403) {
    //   // Functions.loadToken(context);
    // }
    // if(response.statusCode != 200) new AlertException("", response.statusCode, Colors.red[900], context);
    // else new AlertException(response.body, response.statusCode, Colors.lightGreenAccent, context);
    
    // print(response.body);
    return response;
  }
  static Future<http.Response> requestSSLOutdated(dynamic context, String method, String endpoint, [ Map<String, dynamic> data = const {}, FirebaseUser user ] ) async {
    String firebaseToken;
    
    String idToken = await API2.getSessionCode();
    
    FirebaseAuth auth = FirebaseAuth.instance;
    if(user == null && context != null) {
      user = StateWidget.of(context).state.user;
    } else if(user == null && context == null) {
      user = await auth.currentUser();  
    }
    if (user != null) firebaseToken = await API2.getFirebaseToken(user);
    
    String fcmToken = await API2.getFCMToken();
    String registrationToken = await API2.getRegistrationToken();
    List<String> deviceDetails = await getDeviceDetails();
    Map<String, String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
      'idToken': idToken,
      'firebaseToken': firebaseToken,
      'fcmToken': fcmToken,
      'deviceName': deviceDetails[0],
      'deviceVersion': deviceDetails[1],
      'identifier': deviceDetails[2]
    };
    http.Response response;
    switch(method) {
      case "PATCH":
        break;
      case "POST":
        response = await sslClient().post(Config.api1ip()+endpoint, headers: headers, body: json.encode(data));
        break;
      case "PUT":
        response = await sslClient().put(Config.api1ip()+endpoint, headers: headers, body: json.encode(data));
        break;
      case "GET":
        response = await sslClient().get(Config.api1ip()+endpoint, headers: headers);
        break;
      case "DELETE":
        response = await sslClient().delete(Config.api1ip()+endpoint, headers: headers);
        break;
      case "HEAD":
        break;
      case "READ":
        break;
      case "READBYTES":
        break;
    };

    
    print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    if(response.statusCode == 403) {
      // Functions.loadToken(context);
    }
    if(response.statusCode != 200) new AlertException("", response.statusCode, Colors.red[900], context);
    else new AlertException(response.body, response.statusCode, Colors.lightGreenAccent, context);
    
    print(response.body);
    return response;
    // String path = "cert.pem";
    // final byteData = await rootBundle.load("wera-app-api/src/$path");
    // final file = File('${(await getTemporaryDirectory()).path}/$path');
    //await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    //var context = SecurityContext.defaultContext;
    //context.useCertificateChain(file.path);
    //HttpClient client = new HttpClient(context: context)..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    //###HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    //###var request = await client.openUrl(method,Uri.parse(api1ip+endpoint));
    //request.headers.set(HttpHeaders.CONTENT_TYPE,'application/x-www-form-urlencoded');
    //request.headers.set('X-Application', appKey);
    //###request.write(data);
    //var response = request.close();
    //###return request.close();
    // http.Response response;
    // String target = api1ip+endpoint;
    // Map<String, dynamic> mybody = {};

    // Map<String, String> headers = {
    //   'Content-type' : 'application/json', 
    //   'Accept': 'application/json',
    // };

    // IdTokenResult firebaseToken;
    // String token = await API2.getToken(user, firebaseToken);
    // mybody = {"idtoken": token};

    // if(data != null)
    //   if (data.isNotEmpty) {
    //     mybody.addAll(data);
    //   }

    // String encoded = jsonEncode(mybody);


    // return response;
  }
  static Future<http.Response> requestOutdated(String method, String endpoint, [ Map<String, dynamic> data = const {}, FirebaseUser user ] ) async {
    http.Response response;
    String target = Config.api1ip()+endpoint;
    Map<String, dynamic> mybody = {};

    Map<String, String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };

    IdTokenResult firebaseToken;
    String token = await API2.getToken(user);
    mybody = {"idToken": token};

    if(data != null)
      if (data.isNotEmpty) {
        mybody.addAll(data);
      }

    String encoded = jsonEncode(mybody);

    switch(method) {
      case "PATCH":
        response = await http.patch(target, body: encoded, headers: headers);
        break;
      case "POST":
        response = await http.post(target, body: encoded, headers: headers);
        break;
      case "PUT":
        break;
      case "GET":
        response = await http.get(target, headers: headers);
        break;
      case "DELETE":
        break;
      case "HEAD":
        break;
      case "READ":
        break;
      case "READBYTES":
        break;
    }
    return response;
  }

}

class APK {

  static Future<Map<String, String>> gatherHead(String url) async {
    var response = await http.head(url);
    if (response.statusCode == 200) {
      return response.headers;
    } else {
      throw Exception('Failed to load HEAD');
    }
  }

  //static Future<Application> gatherInfo() async {
  //  Application app = await DeviceApps.getApp('com.wera.wera_app');
  //  return app;
  //}

  static downloadFile(String url, Function callback, {String filename}) async {
    var httpClient = http.Client();
    var request = new http.Request('GET', Uri.parse(url));
    var response = httpClient.send(request);
    String dir = (await getApplicationDocumentsDirectory()).path;
    
    List<List<int>> chunks = new List();
    int downloaded = 0;
    
    response.asStream().listen((http.StreamedResponse r) {
      
      r.stream.listen((List<int> chunk) {
        // Display percentage of completion
        // debugPrint('downloadPercentage: ${downloaded / r.contentLength * 100}');
        callback(downloaded / r.contentLength);

        chunks.add(chunk);
        downloaded += chunk.length;
      }, onDone: () async {
        // Display percentage of completion
        // debugPrint('done - downloadPercentage: ${downloaded / r.contentLength * 100}');
        callback(downloaded / r.contentLength);

        // Save the file
        File file = new File('$dir/$filename');
        final List<int> bytes = List<int>(r.contentLength);
        int offset = 0;
        for (List<int> chunk in chunks) {
          bytes.setRange(offset, offset + chunk.length, chunk);
          offset += chunk.length;
        }
        await file.writeAsBytes(bytes);
        APK.open(file);
        return;
      });
    });
  }

  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.apk');
  }

  //static open() async {
  //  _localPath.then( (p) { OpenFile.open(p); });
  //}

  static open(File file) async {
    OpenFile.open(file.path);
  }


  static Future<File> writeFile(List<int> content) async {
    final file = await _localFile;
    //Stream<List<int>> stream = Stream.fromFuture(file);
    // Write the file.
    file.delete();
    file.create();
    return file.writeAsBytes(content);
  }

  static Future<List<int>> readFile() async {
    try {
      final file = await _localFile;

      // Read the file.
      List<int> contents = await file.readAsBytes();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return e;
    }
  }


  /*static setUpAll() async {
    // Create a temporary directory.
    final directory = await Directory.systemTemp.createTemp();

    // Mock out the MethodChannel for the path_provider plugin.
    const MethodChannel('plugins.flutter.io/path_provider')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      // If you're getting the apps documents directory, return the path to the
      // temp directory on the test environment instead.
      if (methodCall.method == 'getApplicationDocumentsDirectory') {
        return directory.path;
      }
      return null;
    });
  }*/

  static List<int> file;

  static Future<File> fetchAPK() async {
    final response = await http.get('{WERA_PROJECTS_DOMAIN}:8000/app.apk');
    if (response.statusCode == 200) {
      APK.file = response.bodyBytes;
      return writeFile(response.bodyBytes);
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future<String> getOnlineVersion() async {
    final response = await http.get('{WERA_PROJECTS_DOMAIN}:8000/version.txt');
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load album');
    }
  }
}

class Network {
  static Future<bool> isOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }
}
