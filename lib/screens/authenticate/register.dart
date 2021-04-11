import 'package:custom_switch/custom_switch.dart';
import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';
import 'package:organo/services/auth.dart';
import 'package:organo/services/database.dart';
import 'package:organo/shared/loading.dart';

class Register extends StatefulWidget {


  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isChecked = false;
  bool diseaseFieldVisibility = false;


  String email = '';
  String password = '';
  String error = '';
  String firstName ='';
  String lastName = '';
  String dissease = '';

  int userType = 1;

  @override
  Widget build(BuildContext context) {
    return loading?Loading():Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Sign up to Organo'),
        actions: [
          FlatButton.icon(onPressed: (){
            widget.toggleView();
          }, icon: Icon(Icons.person), label: Text('Sign in'))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'FirstName',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                validator: (val) => val.isEmpty?'FirstName cannot be blank':null,
                onChanged: (val){
                  setState(() {
                    firstName = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'LastName',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                onChanged: (val){
                  setState(() {
                    lastName = val;
                  });
                },
              ),SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                validator: (val) => val.isEmpty?'Enter a valid email Id':null,
                onChanged: (val){
                  setState(() {
                    email = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                decoration: InputDecoration(
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.amber, width: 2.0),
                  ),
                ),
                validator: (val) => val.length<=5?'Password should be more than 5 characters':null,
                obscureText: true,
                onChanged: (val){
                  setState(() {
                    password = val;
                  });
                },
              ),
              SizedBox(height: 20.0,),
              Visibility(
                visible: diseaseFieldVisibility,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Disease',
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.amber, width: 2.0),
                    ),
                  ),
                  validator: (val) => val.isEmpty?'Enter the Disease of the patient':null,
                  onChanged: (val){
                    setState(() {
                      dissease = val;
                    });
                  },
                ),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Donor',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        isChecked = !isChecked;
                        userType = userType == 1?2:1;
                        diseaseFieldVisibility = !diseaseFieldVisibility;
                      });
                    },
                    child: Center(
                      child: CustomSwitchButton(
                        backgroundColor: Colors.brown,
                        unCheckedColor: Colors.blue,
                        checkedColor:Colors.red ,
                        checked: isChecked,
                        animationDuration: Duration(milliseconds: 400),
                        buttonHeight: 30,
                        buttonWidth: 60,
                        indicatorWidth: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Text(
                    'Patient',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0,),
              RaisedButton(
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() {
                      loading=true;
                    });
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password,firstName,lastName,dissease,userType);
                    if(result == null){
                      setState(() {
                        error = 'Please enter valid details';
                        loading = false;
                      });
                    }

                  }
                },
                color: Colors.pink[400],
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 12.0,),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );;
  }
}
