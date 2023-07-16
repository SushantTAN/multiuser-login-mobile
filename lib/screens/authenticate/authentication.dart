import 'package:flutter/material.dart';
import 'package:multiuser_login/screens/authenticate/signin.dart';
import 'package:multiuser_login/screens/authenticate/register.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignin = true;
  void toggleFunc(){
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showSignin){
      return Signin(toggleSignin: toggleFunc);
    }else{
      return Register(toggleSignin: toggleFunc);
    }
  }
}