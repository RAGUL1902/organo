import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:organo/models/user.dart';

class DatabaseService {



  String firstName, lastName,address, phoneNumber, disease, email;

  final String uid;
  DatabaseService( {this.uid});

  final CollectionReference usersCollection = Firestore.instance.collection('Users');

  Future userSetup (String firstName, String lastName, String email, String disease, int userType ) async{

     await usersCollection.document(uid).setData({
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'uid': uid,
      'address': '',
      'phoneNumber': '',
      'userType': userType,
      'disease': disease,
       'requests': [],
       'friends': [],
       'sentRequests' : [],
       'imageUrl':'https://thumbs.dreamstime.com/b/no-image-available-icon-flat-vector-no-image-available-icon-flat-vector-illustration-132482930.jpg'
    });
    getUserInfo();
  }

  getUserInfo() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    DocumentSnapshot documentSnapshot = await usersCollection.document(uid).get();
    userInfo(documentSnapshot.data);
  }

  userInfo(Map document){

    firstName = document['firstName'];
    lastName = document['lastName'];
    phoneNumber = document['phoneNumber'];
    disease = document['disease'];
    address = document['address'];
    email = document['email'];


    print(firstName);
    print(lastName);
    print(email);
    print(disease);

  }
  printf(){
    print(firstName);
  }

  List<User> _userListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc) {
      return User(
        firstName: doc.data['firstName'],
        lastName: doc.data['lastName'],
        phoneNumber: doc.data['phoneNumber'],
        address: doc.data['address'],
        email: doc.data['email'],
        disease: doc.data['disease'],
        uid: doc.data['uid'],
        userType: doc.data['userType'],
        requests: doc.data['requests'],
        friends: doc.data['friends'],
          sentRequests: doc.data['sentRequests']
      );
    }).toList();
  }


  Stream<List<User>> get users {
    return usersCollection.snapshots()
    .map(_userListFromSnapshot);
  }

}






