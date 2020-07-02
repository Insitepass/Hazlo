

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hazlo/Model/User.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // ignore: slash_for_doc_comments
  /**Stream<User> get user {
    //return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }
**/




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
    // TODO guess add get user details
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

    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

// getting the current userid
// ignore: slash_for_doc_comments
/**final FirebaseAuth _auth = FirebaseAuth.instance;
/getCurrentUser() async {
  final FirebaseUser user = await _auth.currentUser();
  final uid = user.uid.toString();
  // Similarly we can get email as well
  //final uemail = user.email;
  print(uid);
  //print(uemail);
    }
  *///

// inserts just the user id in  database collection
/**Future<void> getN
 * oteDoc() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;
  FirebaseUser user = await _auth.currentUser();
  DocumentReference  ref = _firestore.collection('Notes').document(user.uid);
  return ref.setData({'UID': user.uid});
}

 */