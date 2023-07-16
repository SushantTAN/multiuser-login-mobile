import 'package:flutter/material.dart';
import 'package:multiuser_login/screens/authenticate/authentication.dart';
import 'package:multiuser_login/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  bool loggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLoggedin();
  }

  void checkLoggedin()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    if( pref.getString('token').length >= 50){
      setState(() {
        loggedIn = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(loggedIn){
      return Home();
    }
    else{
      return Authenticate();
    }
    
  }
}