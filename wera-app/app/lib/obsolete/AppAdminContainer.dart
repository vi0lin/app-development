import 'package:app/port/app-hierarchy/App.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//import 'package:flutter/src/services/asset_bundle.dart';

final Color backgroundColor = Color(0xFFfAFA58);

class AppAdminContainer2 extends StatefulWidget {
    @override
    _AppAdminContainer2State createState() => _AppAdminContainer2State();
}

class _AppAdminContainer2State extends State<AppAdminContainer2> {

    // WebViewController _controller;

    bool isCollapsed = true;
    double screenWidth, screenHeight;
    final Duration duration = const Duration(milliseconds: 300);

    @override
    Widget build(BuildContext context) {
        Size size = MediaQuery.of(context).size;
        screenHeight = size.height;
        screenWidth = size.width;
        return Scaffold(
            backgroundColor: backgroundColor,
            body: Stack(
                children: <Widget>[
                    //menu(context),
                    //dashboard(context),
                    //TabbedAppBarSample(),
                    App(),
                ],
            ),
        );
    }

    Widget menu(context) {
        return AnimatedPositioned(
            duration: duration,
            top: isCollapsed ? 0 : screenHeight,
            bottom: isCollapsed ? 0 : 0,
            left: isCollapsed ? 0 : 0.6*screenWidth,
            right: isCollapsed ? 0 : -0.4*screenWidth,
            child: Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column( 
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Text("Dashboard", style: TextStyle(color: Colors.white, fontSize: 20)), 
                            SizedBox(height:10),
                            Text("Messages", style: TextStyle(color: Colors.white, fontSize: 20)), 
                            SizedBox(height:10),
                            Text("Utility Bills", style: TextStyle(color: Colors.white, fontSize: 20)), 
                            SizedBox(height:10),
                            Text("Funds Transfer", style: TextStyle(color: Colors.white, fontSize: 20)), 
                            SizedBox(height:10),
                            Text("Branches", style: TextStyle(color: Colors.white, fontSize: 20)), 
                        ],
                    ),
                ),
            ),
        );
    }

    Widget dashboard(context) {
        _loadHtmlFromAssets();
        return Scaffold(
            backgroundColor: backgroundColor,
            appBar: AppBar(title: Text('Neustart')),
            body: /*WebView(
                initialUrl: 'about:blank',
                onWebViewCreated: (WebViewController webViewController) {
                  _controller = webViewController;
                },
            ),*/ Text("Test")
        );
        //return Material(
        //    elevation: 8,
        //    color: backgroundColor,
        //    child: Container(
        //        child: Column(
        //            children: <Widget>[
        //                Container(
        //                    color: Colors.black,
        //                    padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 12), 
        //                    child:
        //                        Row(
        //                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                            mainAxisSize: MainAxisSize.max,
        //                            children: [
        //                                new Image.asset(
        //                   Container(
        //                    color: Colors.black,
        //                    padding: const EdgeInsets.only(left: 16, right: 16, top: 48, bottom: 12), 
        //                    child:
        //                        Row(
        //                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                            mainAxisSize: MainAxisSize.max,
        //                            children: [
        //                                    'img/wera-logo.png',
        //                                    width: 61.0,
        //                                    height: 51.0,
        //                                    fit: BoxFit.cover,
        //                                ), 
        //                                //InkWell(
        //                                //    child: Icon(Icons.menu, color: Colors.white),
        //                                //    onTap: () {
        //                                //        setState(() {
        //                                //            isCollapsed = !isCollapsed; 
        //                                //        });      
        //                                //    },
        //                                //),
        //                                //Text("Menü", style: TextStyle(fontSize: 24, color: Colors.white)),
        //                                Icon(Icons.settings, color: Colors.white),
        //                            ],
        //                        ), 
        //                ), //Header 
        //                /*Stack(
        //                    children: <Widget>[
        //                        new Image.asset('img/background-shaded.png', width: 640.0, fit: BoxFit.cover, ),
        //                        Column( 
        //                            mainAxisSize: MainAxisSize.min,
        //                            mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                            crossAxisAlignment: CrossAxisAlignment.start,
        //                            children: <Widget>[
        //                                Text("Test", style: TextStyle(color: Colors.white, fontSize: 20)), 
        //                                SizedBox(height:10),
        //                                Text("Text", style: TextStyle(color: Colors.white, fontSize: 20)), 
        //                                SizedBox(height:10),
        //                                Text("Akkorde", style: TextStyle(color: Colors.white, fontSize: 20)), 
        //                                SizedBox(height:20),
        //                                // Text("Lied vorschlagen", style: TextStyle(color: Colors.white, fontSize: 20)), 
        //                                WebView(
        //                                    initialUrl: 'about:blank',
        //                                    onWebViewCreated: (WebViewController webViewController) {
        //                                        _controller = webViewController;
        //                                    },
        //                                ),
        //                            ],
        //                        ),
        //                    ],
        //                ), //Content */
        //                Scaffold(
        //                    appBar: AppBar(title: Text('Help')),
        //                    body: WebView(
        //                        initialUrl: 'about:blank',
        //                        onWebViewCreated: (WebViewController webViewController) {
        //                        _controller = webViewController;
        //                        },
        //                    ),
        //                ),
        //                Row(
        //                                 
        //                ), //Footer
        //            ],
        //        ),
        //    ),
        //);
    }

    // final AssetBundle rootBundle = _initRootBundle();
    _loadHtmlFromAssets() async {
        String fileText = await rootBundle.loadString('assets/Neustart.html');
        /*_controller.loadUrl(
            Uri.dataFromString(
                fileText,
                mimeType: 'text/html',
                encoding: Encoding.getByName('utf-8')
            ).toString()
        );*/
    }

}
