import 'package:flutter/material.dart';
import 'package:organo/models/user.dart';
import 'package:organo/screens/authenticate/authenticate.dart';
import 'package:organo/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    if(user == null){
      return Authenticate();
    }
    else{
      return Home();
    }




  }
}
