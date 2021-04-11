import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/shared/requestCard.dart';


class Requests extends StatefulWidget {
  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {

  List requests = [] ;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: requests.map((e) => RequestCard(uid:e,
        remove: () {
          setState(() {
          requests.remove(e);
          });
        }),
    ).toList(),
      ),
    );
  }
  getUserInfo() async{
    CollectionReference users = Firestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    DocumentSnapshot documentSnapshot = await users.document(uid).get();
    var document = documentSnapshot.data;
    setState(() {
      requests = List.from(document['requests']);
    });
  }


  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

}
