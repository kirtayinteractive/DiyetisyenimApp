import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier{
    final googlesignin=GoogleSignIn();
    GoogleSignInAccount? _user;
    GoogleSignInAccount get user =>_user!;

  Future googleLogin() async {
    final GoogleSignInAccount? googleUser = await googlesignin.signIn();
    if(googleUser==null) return;
    _user=googleUser;

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    notifyListeners();
  }
  Future GoogleSignOut() async{
     googlesignin.signOut();
    notifyListeners();
  }

}
