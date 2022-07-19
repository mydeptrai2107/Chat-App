import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _googleSignIn = GoogleSignIn();
  final _firebaseFirestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if(googleUser == null) {
      return;
    } 
    
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken:  googleAuth.idToken
    );

    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExists = await _firebaseFirestore.collection('users').doc(userCredential.user!.uid).get();

    await _firebaseFirestore.collection('users').doc(userCredential.user!.uid).set({
      'email': userCredential.user!.email,
      'name': userCredential.user!.displayName,
      'image': userCredential.user!.photoURL,
      'uid': userCredential.user!.uid,
      'date': DateTime.now()
    });
  }

  signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  Future<UserModel> getUserCurrent() async {
    User? user = _auth.currentUser;
    DocumentSnapshot userData = await _firebaseFirestore.collection('users').doc(user?.uid).get();
    UserModel userModel = UserModel.fromJson(userData);
    return userModel;
  }

  Future<UserModel> getUserById(String id) async {
    DocumentSnapshot userData = await _firebaseFirestore.collection('user').doc(id).get();
    UserModel userModel = UserModel.fromJson(userData);
    return userModel;
  }
}