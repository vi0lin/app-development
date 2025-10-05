import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/port/app-hierarchy/StateWidget.dart';
import 'LoginScreen.dart';


class UserProfile extends StatelessWidget {

  Widget _buildContent(context) {
    if (StateWidget.of(context).state.isLoading) {
      return _buildLoadingIndicator();
    } else if (!StateWidget.of(context).state.isLoading && StateWidget.of(context).state.user == null) {
      return new LoginScreen();
    } else {
      return _buildHomeScreen(context);
    }
  }

  Widget _buildLoadingIndicator() {
    return Text("loading");
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    return _buildContent(context);
  }

  Widget _buildHomeScreen(context, {Widget body}) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text('User'),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,         
            children: <Widget>[          
              new Container(
                padding: EdgeInsets.all(20.0),
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(StateWidget.of(context).state.user.photoUrl.toString()),
                  ),
                )),         
              new Text(            
                'Hallo, ' '${StateWidget.of(context).state.user.displayName}' ' !',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 25),
              )
          ],
        )),
      ),
    );
  }
}