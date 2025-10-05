import 'package:app/port/utils/config.dart';
import 'package:app/port/widgets/MyArticleList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//class Home extends StatelessWidget {
class Home extends StatefulWidget {

  Home({Key key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with WidgetsBindingObserver /* with SingleTickerProviderStateMixin */ {

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    return _buildHomeScreen();
  }

  Widget _buildHomeScreen({Widget body}) {
    return Scaffold(
      // appBar: AppBar(
        // backgroundColor: Colors.black87,
        // title: Text('Home'),
      // ),
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: MyArticleList(key: Config.homeKey)
        ),
      ),
    );
  }
}