import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/models/user.dart';


class RequestCard extends StatefulWidget {

  String uid;
  final Function remove;
  RequestCard({this.uid, this.remove});


  @override
  _RequestCardState createState() => _RequestCardState();
}

class _RequestCardState extends State<RequestCard> {

  String firstName =' ', lastName= ' ', email = ' ';

  bool cancelButton = true;
  bool acceptButton = true;
  bool accepted = false;
  bool rejected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              firstName+lastName,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(
              height: 6.0,
            ),
            Text(
              email,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Visibility(
              visible: acceptButton,
              child: FlatButton.icon(

                onPressed: () async {

                  CollectionReference users = Firestore.instance.collection('Users');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseUser current_user = await auth.currentUser();
                  String uid = current_user.uid;
                  await users.document(widget.uid).updateData({
                    'friends': FieldValue.arrayUnion([uid])
                  });
                  await users.document(uid).updateData({
                    'friends': FieldValue.arrayUnion([widget.uid])
                  });
                  await users.document(uid).updateData({
                    'requests': FieldValue.arrayRemove([widget.uid])
                  });
                  await users.document(widget.uid).updateData({
                    'sentRequests': FieldValue.arrayRemove([uid])
                  });
                  setState(() {
                    accepted = true;
                    rejected = false;
                    acceptButton = false;
                    cancelButton = false;
                  });
                    widget.remove;
                    },
                label: Text('Accept', style: TextStyle(fontSize: 20),),
                icon: Icon(Icons.person_add),
              ),
            ),
            Visibility(
              visible: cancelButton,
              child: FlatButton.icon(
                onPressed: () async {

                  CollectionReference users = Firestore.instance.collection('Users');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseUser current_user = await auth.currentUser();
                  String uid = current_user.uid;
                  await users.document(uid).updateData({
                    'requests': FieldValue.arrayRemove([widget.uid])
                  });
                  await users.document(widget.uid).updateData({
                    'sentRequests': FieldValue.arrayRemove([uid])
                  });
                  setState(() {
                    widget.remove;
                    accepted = false;
                    rejected = true;
                    acceptButton = false;
                    cancelButton = false;
                  });
                },
                label: Text('Reject', style: TextStyle(fontSize: 20),),
                icon: Icon(Icons.cancel),
              ),
            ),
            Visibility(
                visible: accepted,
                child: Row(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: Text('Accepted', style: TextStyle(fontSize: 20),),
                    )),
                    Icon(Icons.check, color: Colors.green,)
                  ],
                )
            ),
            Visibility(
                visible: rejected,
                child: Row(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: Text('Rejected', style: TextStyle(fontSize: 20),),
                    )),
                    Icon(Icons.cancel, color: Colors.redAccent,)
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }

  getUserInfo(String uid) async{
    CollectionReference users = Firestore.instance.collection('Users');
    DocumentSnapshot documentSnapshot = await users.document(uid).get();
    var document = documentSnapshot.data;
    setState(() {
      firstName = document['firstName'];
      lastName = document['lastName'];
      email = document['email'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo(widget.uid);
  }


}