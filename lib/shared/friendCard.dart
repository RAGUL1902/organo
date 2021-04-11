import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/shared/userProfile.dart';


class FriendCard extends StatefulWidget {

  String uid;
  Function remove;
  FriendCard({this.uid,this.remove});

  @override
  _FriendCardState createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {

  String firstName = ' ', lastName = ' ', email = ' ';

  bool unfriended = false;

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
              visible: !unfriended,
              child: FlatButton.icon(

                onPressed: () async {
                  CollectionReference users = Firestore.instance.collection('Users');
                  FirebaseAuth auth = FirebaseAuth.instance;
                  FirebaseUser current_user = await auth.currentUser();
                  String uid = current_user.uid;
                  await users.document(widget.uid).updateData({
                    'friends': FieldValue.arrayRemove([uid])
                  });
                  await users.document(uid).updateData({
                    'friends': FieldValue.arrayRemove([widget.uid])
                  });
                  widget.remove;
                  setState(() {
                    unfriended = !unfriended;
                  });
                },
                label: Text('Unfriend', style: TextStyle(fontSize: 20),),
                icon: Icon(Icons.person_remove),
              ),
            ),
            Visibility(
              visible: !unfriended,
              child: FlatButton.icon(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfile(uid: widget.uid,)),
                  );
                },
                label: Text('View Profile', style: TextStyle(fontSize: 20),),
                icon: Icon(Icons.person),
              ),
            ),
            Visibility(
                visible: unfriended,
                child: Row(
                  children: [
                    Center(child: Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: Text('Unfriended', style: TextStyle(fontSize: 20),),
                    )),
                    Icon(Icons.cancel, color: Colors.redAccent,)
                  ],
                ))
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
