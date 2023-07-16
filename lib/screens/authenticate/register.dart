import 'package:flutter/material.dart';
import 'package:multiuser_login/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleSignin;
  Register({this.toggleSignin});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
      body: Center(
        
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('http://4.bp.blogspot.com/-FyJuSNsRrWs/TibLzmYFU3I/AAAAAAAAK40/0BGwL0v2eyk/s1600/cool+computer+backgrounds-2.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Form(
            child: SingleChildScrollView(
                          child: Column(
                children: <Widget>[

                  SizedBox(height: 40),

                  Text("Register", 
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      ),
                  ),

                  SizedBox(height: 90),

                  Text("Email",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration,
                  ),
                  SizedBox(height: 10,),

                  Text("Password",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  ),
                  TextFormField(
                    decoration: textInputDecoration,
                  ),
                  SizedBox(height: 10),

                  RaisedButton(
                    onPressed: ()async{
                     
                     
                    },
                    child: Text("Register for free",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.blue[500],
                  ),

                  SizedBox(height: 100),

                  Row(
                    children: <Widget>[
                      Text("Already have an account?",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      ),
                      RaisedButton(
                        onPressed: (){
                          widget.toggleSignin();
                        },
                        color: Colors.green[100],
                        child: Text("Sign In"),
                    ),
                    ],

                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}