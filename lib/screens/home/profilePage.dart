import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organo/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String firstName, lastName,address, phoneNumber, disease, email;
  int userType;

  File _image;
  String fileName;
  String url =' ';


  @override
  Widget build(BuildContext context) {

    Future getImage() async{
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        fileName = basename(image.path);
      });

    }

    Future uploadPic(BuildContext context) async{
      print(fileName);
      StorageReference firebaseStorageReference = FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageReference.putFile(_image);
      var downurl = await  (await uploadTask.onComplete).ref.getDownloadURL();
       url = downurl.toString();
      print(url);
      // setState(() {
      //
      // });
    }


    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25,right: 16),
              child: ListView(
                children: [
                  Text(
                    'Edit Profile',
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
                              image: (_image != null)?FileImage(File(_image.path))
                              :NetworkImage(url),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom:0,
                            right: 0,
                            child:GestureDetector(
                              onTap: (){
                                getImage();
                              },
                              child: Container(


                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context).scaffoldBackgroundColor
                                  ),
                                  color: Colors.brown,
                          ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                        ),
                            ) ),
                      ],
                    ),
                  ),
                  SizedBox(height:35),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        onChanged: (val){
                          setState(() {
                            firstName = val;
                          });
                        },
                        decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'First Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: firstName,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                      onChanged: (val){
                        setState(() {
                          lastName = val;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Last Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: lastName,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Email Id',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: email,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                      onChanged: (val){
                        setState(() {
                          phoneNumber = val.toString();
                        });
                      },
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Phone Number',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: phoneNumber,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                      onChanged: (val){
                        setState(() {
                          address = val;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: 'Address',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: address,
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),

                      ),
                    ),
                  ),
                  Visibility(
                    visible: userType == 2,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: TextField(
                        onChanged: (val){
                          setState(() {
                            disease = val;
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Disease',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: disease,
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  RaisedButton(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                      shape:RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      onPressed: (){
                        setState(() {
                          var result =updateUserInfo();
                          uploadPic(context);
                          if(result == null) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Unsuccessful, Try again later "),
                            ));
                          }
                          else{
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text("Changes Saved Successfully"),
                            ));
                          }
                        }
                        );
                      },
                    color: Colors.green,
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        fontSize: 14,
                        letterSpacing: 2.2,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  updateUserInfo() async{
    CollectionReference users = Firestore.instance.collection('Users');
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    String uid = user.uid;
    return await users.document(uid).updateData({
      'firstName' : firstName,
      'lastName' : lastName,
      'phoneNumber': phoneNumber,
      'email': email,
      'disease': disease,
      'address': address,
      'imageUrl': url
    });
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
      url = document['imageUrl'];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }



}
