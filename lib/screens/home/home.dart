import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:organo/screens/home/otherUsers.dart';
import 'package:organo/screens/home/profilePage.dart';
import 'package:organo/screens/home/requests.dart';
import 'package:organo/services/auth.dart';

import 'friends.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();


  String firstName, lastName,address, phoneNumber, disease, email;
  int userType;
  List friends;
  List sentRequests;

  bool profileSelected = true;
  bool requestsSelected = false;
  bool usersSelected = false;
  bool friendsSelected = false;


  Widget widgetForBody = ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('Organo'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: [
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('Log out'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Center(
                child: Text(
                    'Main Menu',
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.black,
                ),),
              ),
              decoration: BoxDecoration(
                color: Colors.brown
              ),
            ),
            ListTile(
              title: Text('Profile', textScaleFactor: 1.5,),
              subtitle: Text('My details'),
              leading: Icon(Icons.person_rounded),
              selected: profileSelected,
              onTap: (){
                setState(() {
                  widgetForBody = ProfilePage();
                  profileSelected = true;
                  requestsSelected = false;
                  usersSelected = false;
                  friendsSelected = false;
                  Navigator.of(context).pop();
                });
              },
            ),
            SizedBox(
              height: 1,
              child: Container(
                color: Colors.black,
              ),
            ),
            ListTile(
              title: Text('Other users', textScaleFactor: 1.5,),
              subtitle: Text('Others Users'),
              leading: Icon(Icons.person_rounded),
              selected: usersSelected,
              onTap: (){
                setState(() {
                widgetForBody = OtherUsers(userType: userType,sentRequests: sentRequests,friends: friends);
                profileSelected = false;
                requestsSelected = false;
                usersSelected = true;
                friendsSelected = false;
                Navigator.of(context).pop();
                });
              },
            ),
            SizedBox(
              height: 1,
              child: Container(
                color: Colors.black,
              ),
            ),ListTile(
              title: Text('Requests', textScaleFactor: 1.5,),
              subtitle: Text('Received requests  '),
              leading: Icon(Icons.person_rounded),
              selected: requestsSelected,
              onTap: (){
                setState(() {
                  widgetForBody = Requests();
                  profileSelected = false;
                  requestsSelected = true;
                  usersSelected = false;
                  friendsSelected = false;
                  Navigator.of(context).pop();

                });
              },
            ),
            SizedBox(
              height: 1,
              child: Container(
                color: Colors.black,
              ),
            ),ListTile(
              title: Text('My Friends', textScaleFactor: 1.5,),
              subtitle: Text('Patients paired with me'),
              leading: Icon(Icons.person_rounded),
              selected: friendsSelected,
              onTap: (){
                setState(() {
                  widgetForBody = Friends();
                  profileSelected = false;
                  requestsSelected = false;
                  usersSelected = false;
                  friendsSelected = true;
                  Navigator.of(context).pop();

                });
              },
            ),
            SizedBox(
              height: 1,
              child: Container(
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    body: widgetForBody,
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
      firstName = document['firstName'];
      lastName = document['lastName'];
      phoneNumber = document['phoneNumber'];
      disease = document['disease'];
      address = document['address'];
      email = document['email'];
      userType = document['userType'];
      friends = document['friends'];
      sentRequests = document['sentRequests'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }


}
