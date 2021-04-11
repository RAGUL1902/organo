import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:organo/models/user.dart';
import 'package:organo/shared/userCard.dart';
import 'package:provider/provider.dart';


class UserList extends StatefulWidget {


  int userType;
  List friends;
  List sentRequests;
  UserList({this.userType,this.sentRequests,this.friends});

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users = Provider.of<List<User>>(context);
    return Column(
            children: users.map((user) {
            if(user.userType != widget.userType){
              return UserCard(
                user: user,
                userType: widget.userType,
                sentRequests: widget.sentRequests,
                friends: widget.friends,
            );

            }
            else{
              return Container();
            }}).toList(),
    );
  }
}
