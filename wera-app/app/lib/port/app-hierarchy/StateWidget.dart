import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/Network.dart';
import '../utils/auth.dart';
import '../utils/config.dart';

bool impersonateUser = false;
bool isAdmin(context) {
  return true;
  //return StateWidget.of(context).state.user != null && (StateWidget.of(context).state.user.email == '{ADMIN_EMAIL_ADRESS}' || StateWidget.of(context).state.user.email == '{ANOTHER_ADMIN_EMAIL_ADRESS}');
}

class StateWidget extends StatefulWidget {
  final StateModel state;
  final Widget child;

  StateWidget({
    @required this.child,
    this.state,
  });

  static _StateWidgetState of(BuildContext context) {
    //return context.dependOnInheritedWidgetOfExactType<_StateDataWidget>();
    return (context.findAncestorWidgetOfExactType<_StateDataWidget>()).data;
  }

  @override
  _StateWidgetState createState() => new _StateWidgetState();
}

class _StateWidgetState extends State<StateWidget> {
  StateModel state;
  GoogleSignInAccount googleAccount;

  final GoogleSignIn googleSignIn = new GoogleSignIn();

  @override
  void initState() {
    super.initState();
    if (widget.state != null) {
      state = widget.state;
    } else {
      state = new StateModel(isLoading: true);
      
      // Network.isOnline().then((isOnline) {
      //   if(isOnline)
      // initUser();
      // });
    }
  }

  Future<Null> signInWithGoogle() async {
    if (googleAccount == null) {
      // Start the sign-in process:
      try {
        googleAccount = await googleSignIn.signIn(); 
      } catch(e) {
        print(e);
      }
    }
    //print('###########---##########');
    try {
      FirebaseUser firebaseUser = await signIntoFirebase(googleAccount);
      setState(() {
        state.isLoading = false;
        state.user = firebaseUser;
      });
    } catch(e) { print(e); }
  }

  Future<Null> initUser() async {
    if (Config.enableLogin) {
      //var connectivityResult = await (Connectivity().checkConnectivity());
      //if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
        //googleAccount = await getSignedInAccount(googleSignIn);
        await signInWithGoogle();
      //}
      /* print("googleAccount############");
      if (googleAccount == null) {
        setState(() {
          state.isLoading = false;
        });
      } else {
        await signInWithGoogle();
      } */
    }
  }

  Future<Null> signOut() async {
    await FirebaseAuth.instance.signOut();
    googleSignIn.signOut();
    setState(() {
      googleAccount = null;
      state.user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _StateDataWidget(
      data: this,
      child: widget.child,
    );
  }
}

class _StateDataWidget extends InheritedWidget {
  final _StateWidgetState data;
  _StateDataWidget({
    Key key,
    @required Widget child,
    @required this.data,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_StateDataWidget old) => true;
}

class StateModel {
  bool isLoading;
  FirebaseUser user;
  StateModel({  
    this.isLoading = false,
    this.user, 
  });
}
