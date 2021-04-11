import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/models/user.dart';


class UserCard extends StatefulWidget {
  User user;
  int userType;
  List friends;
  List sentRequests;

  UserCard({this.user,this.userType,this.friends,this.sentRequests});

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  int userType;

  bool cancelButton;
  bool reqButton;
  bool friendsText;



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
                widget.user.firstName + widget.user.lastName,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: 6.0,
              ),
              Text(
                widget.user.email,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Visibility(
                visible: reqButton,
                child: FlatButton.icon(

                  onPressed: () async {

                    CollectionReference users = Firestore.instance.collection('Users');
                    FirebaseAuth auth = FirebaseAuth.instance;
                    FirebaseUser current_user = await auth.currentUser();
                    String uid = current_user.uid;
                    try{
                      await users.document(widget.user.uid).updateData({
                      'requests': FieldValue.arrayUnion([uid])
                    });
                  }catch(e) {
                    print(e);
                    }
                    await users.document(uid).updateData({
                      'sentRequests': FieldValue.arrayUnion([widget.user.uid])
                    });
                    setState(() {
                      reqButton = false;
                      cancelButton = true;
                      friendsText = false;
                    });

                  },
                  label: Text('Send Request', style: TextStyle(fontSize: 20),),
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
                    await users.document(widget.user.uid).updateData({
                      'requests': FieldValue.arrayRemove([uid])
                    });
                    await users.document(uid).updateData({
                      'sentRequests': FieldValue.arrayRemove([widget.user.uid])
                    });
                    setState(() {
                      reqButton = true;
                      cancelButton = false;
                      friendsText = false;
                    });
                  },
                  label: Text('Cancel Request', style: TextStyle(fontSize: 20),),
                  icon: Icon(Icons.person_add),
                ),
              ),
              Visibility(
                visible: friendsText,
                  child: Row(
                    children: [
                      Center(child: Padding(
                        padding: const EdgeInsets.only(left: 160),
                        child: Text('Friends', style: TextStyle(fontSize: 20),),
                      )),
                      Icon(Icons.check, color: Colors.green,)
                    ],
                  ))
            ],
          ),
        ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setButtons();
  }

  setButtons(){
    if(widget.friends != null) {
      if (widget.friends.contains(widget.user.uid)) {
        setState(() {
          cancelButton = false;
          reqButton = false;
          friendsText = true;
        });
      }
      else {
        if (widget.sentRequests.contains(widget.user.uid)) {
          setState(() {
            cancelButton = true;
            reqButton = false;
            friendsText = false;
          });
        }
        else {
          setState(() {
            cancelButton = false;
            reqButton = true;
            friendsText = false;
          });
        }
      }
    }
    else{
      print('widget.friends is ${widget.friends}');
    }
  }

}