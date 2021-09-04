
import 'package:hazlo/Model/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseUser _user;


  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, email: user.email,name: user.displayName) : null;
  }


// Login in user with email and password
  Future signInWithEmailAndPassword( String _emailField, String _passwordField) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: _emailField.trim(), password: _passwordField.trim());
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    } catch (e) {
      print(e.toString());
      return null;
    }
  }

// Register User with email and password
  Future registerWithEmailAndPassword( String _emailField, String _passwordField) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: _emailField.trim(), password: _passwordField.trim());


      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;

    }

  }
// sign in with google
  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: [
          'email'
        ],
        hostedDomain: "",
        clientId: "",
      );
      final FirebaseAuth _auth = FirebaseAuth.instance;

      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken
      );
      final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
      print("signed in" + user.displayName);

      return true;
    } catch (e) {
      print(e.message);

      return false;
    }
  }
  //sign out function
  signOut() async {
    try{
      await FirebaseAuth.instance.signOut();
      await _googleSignIn.signOut();

    } catch (e) {
      print('Failed to signOut '+ e.toString());
      return null;
    }
  }

  // isLogging State
  Future<bool> isLoggedIn() async {
    this._user = await _auth.currentUser();
    if (this._user == null) {
      return false;
    }
    return true;

  }


// Reset password
  Future<void> resetPassword(String _emailField) async {
    await _auth.sendPasswordResetEmail(email:_emailField.trim());
  }



  // // Delete User
  // Future deleteUser(String _emailField,String _passwordField) async {
  //   try{
  //     FirebaseUser user = await _auth.currentUser();
  //     AuthCredential credentials = EmailAuthProvider.getCredential(email:_emailField.trim(), password: _passwordField.trim() );
  //     print(user);
  //
  //     AuthResult result = await user.reauthenticateWithCredential(credentials);
  //     await DatabaseService(result.user.uid).deleteAccount(); // this method is in the db_service.
  //     await result.user.delete();
  //     return true;
  //
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

// re-authenticate user
//   static Future<FirebaseUser> reauthCurrentUser() async {
//     FirebaseUser fbUser = await FirebaseAuth.instance.currentUser();
//     // this object holds user email and password needed to make reauth.
//     FirebaseUser signedUser = FirebaseAuth.instance as FirebaseUser;
//     AuthCredential credential;
//
//     // assumuming that user auth using email & password
//     credential = EmailAuthProvider.getCredential(
//         email: signedUser.email,
//         password: password);
//
//     fbUser = (await fbUser.reauthenticateWithCredential( credential )
//         .catchError((error){ print("FirebaseAuthHelper::reauthCurrentUser $error"); })) as FirebaseUser;
//     // force reloading...
//     await fbUser.reload();
//     return fbUser;
//   }


// Getting the user Name
  initializeCurrentUser(AuthService authNotifier) async {
    FirebaseUser firebaseUser = await FirebaseAuth.instance.currentUser();

    if(firebaseUser !=null) {
      print(firebaseUser);
      authNotifier._userFromFirebaseUser(firebaseUser);
    }
  }

}










