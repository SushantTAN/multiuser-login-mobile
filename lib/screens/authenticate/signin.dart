
import 'dart:ui';
import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multiuser_login/screens/home/home.dart';
import 'package:multiuser_login/shared/constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


Future<void> doLogin (String email, String password) async {

 try{ 
  Map data ={
	    'email': email, 
	    'password': password
    };
  //encode map to json
  var body = json.encode(data);

  var response = await http.post( 'https://polar-plains-75515.herokuapp.com/api/user/login', 
    headers: {"Content-Type": "application/json"},
    body: body
    );
  //var jsonData = jsonDecode(response.body);

  //print(response.body);

  //set shared preferences
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString('token', response.body);

  

  }
  catch(e){
    print(e);
  }
}


class Signin extends StatefulWidget {

  final Function toggleSignin;
  Signin({this.toggleSignin});

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  String email = '';
  String password = '';
  String error = '';

  // bool loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
            child: Column(
              children: <Widget>[
                
                SizedBox(height: 40),

                Text("Login", 
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
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(height: 10,),

                Text("Password",
                style: TextStyle(
                  color: Colors.white,
                ),
                ),
                TextFormField(
                  decoration: textInputDecoration,
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(height: 10),

                RaisedButton(
                  onPressed: ()async{
                    await doLogin(email, password);
                    SharedPreferences pref = await SharedPreferences.getInstance();
                    print(pref.getString('token'));
                    if(pref.getString('token').length >= 50){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                        );
                    }
                  },
                  child: Text("Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.blue[500],
                ),

                SizedBox(height: 100),

                Row(
                  children: <Widget>[
                    Text("Don't have an account?",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    ),
                    RaisedButton(
                      onPressed: (){
                        widget.toggleSignin();
                      },
                      color: Colors.green[100],
                      child: Text("Register"),
                  ),
                  ],

                ),
                

              ],
            ),
          ),

        ),
      ),
    );
  }
}