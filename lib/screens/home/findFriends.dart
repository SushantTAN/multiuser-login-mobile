
import 'dart:ui';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:multiuser_login/helper/user_helper.dart';
import 'package:multiuser_login/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FindFriends extends StatefulWidget {
  @override
  _FindFriendsState createState() => _FindFriendsState();
}

class _FindFriendsState extends State<FindFriends> {
  
  List<UserModel> allUsers;
  var usableFollowing;
  UserModel loggedUser;
  

  String searchbar;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllUsers();
    //setLoggedUser();
  }

  getAllUsers()async{
    User newUser = User();
    await newUser.getAllUsers();

    //print(newUser.allusers);
    setState(() {
     allUsers = newUser.allusers;
    });

    await newUser.getLoggedData();
    setState(() {
      usableFollowing = newUser.usableFollowing;
    });
  }

  // setLoggedUser()async{
  //   User newUser = User();
  //   await newUser.getUser();
  //   setState(() {
  //     loggedUser= newUser.loggedUser;
  //   });
  // }

  Future<void> follow(var id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      "from": pref.getString("id"),
      "to": id
    };
    //encode map to json
    var body = json.encode(data);
    var response1 = await http.post(
      'https://polar-plains-75515.herokuapp.com/api/user/follow',
      headers: {"Content-Type": "application/json"},
      body: body
      );
    print(response1);

    var response2 = await http.post(
      'https://polar-plains-75515.herokuapp.com/api/user/following',
      headers: {"Content-Type": "application/json"},
      body: body
      );
    print(response2);

    User newUser = User();
    await newUser.getLoggedData();
    setState(() {
      usableFollowing = newUser.usableFollowing;
    });

    
  }

  Future<void> unfollow(var id)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    Map data = {
      "from": pref.getString("id"),
      "to": id
    };
    //encode map to json
    var body = json.encode(data);
    var response1 = await http.post(
      'https://polar-plains-75515.herokuapp.com/api/user/unfollowing',
      headers: {"Content-Type": "application/json"},
      body: body
      );
    print(response1);

    var response2 = await http.post(
      'https://polar-plains-75515.herokuapp.com/api/user/unfollow',
      headers: {"Content-Type": "application/json"},
      body: body
      );
    print(response2);

    User newUser = User();
    await newUser.getLoggedData();
    setState(() {
      usableFollowing = newUser.usableFollowing;
    });

    
  }

  renderButton(var id){
    bool following = false;
    usableFollowing.forEach((c) {
      if(c == id){
        following = true;
      }
    });

    if(following){
      return RaisedButton(
        onPressed: (){
          unfollow(id);
        },
        color: Colors.yellow[300],
        child: Text("Unfollow"),
      );
    }else{
      return  RaisedButton(
        onPressed: (){
          follow(id);
        },
        color: Colors.green[300],
        child: Text("Follow"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Form(
        child: Column(
          children: <Widget>[
            Text("Search for friends' name:",
              textAlign: TextAlign.start,
            ),
            TextFormField(
              onChanged: (val){
                setState(() {
                  searchbar = val;
                });
              },
            ),

            //render list
          ],
        )
              ),

              SizedBox(height: 20),

              //all users
              Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Text(
            "Name",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          Text(
            "Befriend",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            ),
          ],
              ),

              ListView.builder(
        itemCount: allUsers.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        itemBuilder: (context, index){
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(allUsers[index].name),
              renderButton(allUsers[index].id)
            ],
          );
        }),

            ],
          ),
      ),
    );
  }
}