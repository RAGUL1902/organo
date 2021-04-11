import 'package:firebase_auth/firebase_auth.dart';
import 'package:organo/models/user.dart';
import 'package:organo/services/database.dart';


class AuthService{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  User _userFromFirebaseUser(FirebaseUser user){
      return user != null? User(uid: user.uid):null;
  }

  //auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  //Sign in anon
  Future signInAnon() async{
    try{
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }catch(e){
      print(e.toString());
      return null;    }
  }


  //Sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      if(user != null){
        DatabaseService().getUserInfo();
        return _userFromFirebaseUser(user);
      }
      return user;
    }catch(e){
      print(e.toString());
      return null;

    }
  }

  //Register with email password
  Future registerWithEmailAndPassword(String email, String password, String firstName, String lastName, String disease, int userType) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      DatabaseService(uid:user.uid).userSetup(firstName, lastName, email, disease, userType);
      return _userFromFirebaseUser(user);
    }catch(e){
        print(e.toString());
        return null;
    }
  }


  //Sign out
  Future signOut() async {
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
}


  Future register(String ) async{



  }




}