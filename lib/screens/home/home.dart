
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:multiuser_login/helper/user_helper.dart';
import 'package:multiuser_login/models/newsfeedModel.dart';
import 'package:multiuser_login/models/userModel.dart';
import 'package:multiuser_login/screens/authenticate/authentication.dart';
import 'package:multiuser_login/screens/home/authUser.dart';
import 'package:multiuser_login/screens/home/findFriends.dart';
import 'package:multiuser_login/screens/home/myposts.dart';
import 'package:multiuser_login/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  UserModel loggeduser;
  List<NewsFeedModel> newsFeed;

  int _index = 0;
  bool _loading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoggedUser();
    getNewsfeed();
  }

  getLoggedUser() async {
    User newUser = User();
    await newUser.getUser();

    setState(() {
      loggeduser = newUser.loggedUser;
    });
  }

  getNewsfeed() async {
    BasicUserData newClass = BasicUserData();
    await newClass.getNewsfeed();
    
    setState(() {
      newsFeed = newClass.newsFeed;
      
    });
    //print(newsFeed[0].description);
  }

  

  forHome(){
    return AuthUser(
        loggeduser1: loggeduser,
        newsFeed1: newsFeed
      );
  }

  forMyposts(){
    return Myposts(
      // myPosts: myPosts,
    );
  }

  forFriends(){
    return(FindFriends());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(

        title: Text("LifeDamage",),
        actions: <Widget>[

          FlatButton(
                      onPressed: ()async{
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        pref.remove('token');
                        pref.remove("id");
                        pref.remove("name");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Authenticate())
                          );
                      }, 
                      child: Text('logout')
                      ,),
              
        ],
      ),

      body: 
        _loading ? Loading() : (_index == 0 ? forHome() : ( _index == 1 ? forMyposts() : forFriends() ))
      ,

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index){
          setState(() {
            _index = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text("Home")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership_rounded),
            title: Text("MyPosts")
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            title: Text("FindFriends")
          ),
        ],
        ),
    );
  }
}