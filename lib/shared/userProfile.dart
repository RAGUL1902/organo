import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {

  String uid;
  UserProfile({this.uid});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
   String firstName;
   String lastName;
   String address;
   String phoneNumber;
   String disease;
   String email;
   String url = ' ';
   int userType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25,right: 16),
        child: ListView(
          children: [
            Text(
              'User Profile',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 15,),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 4,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      boxShadow:[
                        BoxShadow(
                          spreadRadius: 2, blurRadius: 10,
                          color: Colors.black.withOpacity(0.1),
                          offset: Offset(0,10),
                        ),
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(url),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height:35),
            Padding(
              padding: const EdgeInsets.only(bottom: 35.0),
              child: Text('First Name: $firstName')
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Text('Last Name: $lastName')
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Text('Eamil : $email')
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Text('Phone Number: $phoneNumber')
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Text('Address: $address')
            ),
            Visibility(
              visible: userType == 2,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: Text('Disease: $disease')
              ),
            ),
          ],
        ),
      ),
    );
  }

  getUserInfo() async{
    CollectionReference users = Firestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    DocumentSnapshot documentSnapshot = await users.document(widget.uid).get();
    var document = documentSnapshot.data;
    setState(() {
      firstName = document['firstName'];
      lastName = document['lastName'];
      phoneNumber = document['phoneNumber'];
      disease = document['disease'];
      address = document['address'];
      email = document['email'];
      userType = document['userType'];
      url = document['imageUrl'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }
}
