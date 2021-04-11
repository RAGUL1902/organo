import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/shared/friendCard.dart';


class Friends extends StatefulWidget {
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  List friends = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: friends.map((e) {
          if(FriendCard(uid:e) != null){
            return FriendCard(uid:e, remove: (){
              setState(() {
                friends.remove(e);
              });
            },);
          }
          else{
            return Container();
          }
        }).toList(),
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
      friends = document['friends'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }



}


