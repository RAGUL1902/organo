import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organo/models/user.dart';
import 'package:organo/screens/home/user_list.dart';
import 'package:organo/services/database.dart';
import 'package:provider/provider.dart';

class OtherUsers extends StatefulWidget {

  int userType;
  List friends;
  List sentRequests;
  OtherUsers({this.userType,this.friends,this.sentRequests});
  @override
  _OtherUsersState createState() => _OtherUsersState();
}

class _OtherUsersState extends State<OtherUsers> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<User>>.value(
      initialData: [],
      value: DatabaseService().users,
      child: Scaffold(
        body: UserList(userType: widget.userType,friends: widget.friends,sentRequests: widget.sentRequests,),
      ),
    );
  }
}
