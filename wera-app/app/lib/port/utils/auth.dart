import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<GoogleSignInAccount> getSignedInAccount(GoogleSignIn googleSignIn) async {
  
  GoogleSignInAccount account = googleSignIn.currentUser;
  if (account == null) {
    try {
      //account = await googleSignIn.signInSilently();
      return googleSignIn.signIn().catchError((onError) {
        print("Error $onError");
      });
    }
    catch(e) {
      print(e);
    }
  } else {
    return account;
  }
}

Future<FirebaseUser> signIntoFirebase(GoogleSignInAccount googleSignInAccount) async {
  FirebaseUser user;
  try {
    if(googleSignInAccount != null) {
      FirebaseAuth _auth = FirebaseAuth.instance;

      GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication; 
      AuthCredential credential = GoogleAuthProvider.getCredential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      //print(credential);
      //print("credential ###########");
      //print(_auth);
      //print("_auth ##################");
      user = (await _auth.signInWithCredential(credential)).user;
    }
  } catch (e) {
    print(e);
  }
  return user;
  //GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
  //print(googleAuth.accessToken);
  //print(googleAuth.idToken);
  //print("##############");
  //return await _auth.signInWithCustomToken(token: googleAuth.accessToken);
  /* final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  print(credential);
  return await _auth.signInWithCredential(credential);*/
}