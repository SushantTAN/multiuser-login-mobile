import 'package:http/http.dart' as http;
import 'package:multiuser_login/models/newsfeedModel.dart';
import 'dart:convert';

import 'package:multiuser_login/models/userModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User{
  UserModel loggedUser;
  List<UserModel> allusers = [];
  var usableFollowing;
  var usableFollowers;

    Future<void> getUser() async {

    try{
      SharedPreferences pref = await SharedPreferences.getInstance();

    var response = await http.get(
      'https://polar-plains-75515.herokuapp.com/api',
      headers: {
        "Content-Type": "application/json",
        "auth-token": pref.getString("token")
        },
      );

    var jsonData = jsonDecode(response.body);

    UserModel userModel = UserModel(
      name: jsonData['name'],
      id: jsonData['_id'],
      following: jsonData['following']
    );

    loggedUser = userModel;

    pref.setString("id", this.loggedUser.id);
    pref.setString("name", this.loggedUser.name);
    }catch(e){
      print(e);
    }
  }

  Future<void> getAllUsers() async {
    var response = await http.get('https://polar-plains-75515.herokuapp.com/api/user/allusers');
    var jsonData = jsonDecode(response.body);
    //print(response.body);

    jsonData.forEach((element) {
      UserModel allUsers = UserModel(
      name: element['name'],
      id: element['_id'],
      following: element['following']
    );

    allusers.add(allUsers);
    });
    //print(allusers);

  }

  Future<void> getLoggedData()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    var response = await http.get('https://polar-plains-75515.herokuapp.com/api/user/loggeduser/${pref.getString("id")}');
    //print(response.body);

    var jsonData = jsonDecode(response.body);
    usableFollowers = jsonData['followers'];
    usableFollowing = jsonData['following'];
  }
  
}

class BasicUserData{
  List<NewsFeedModel> newsFeed = [];
  List<NewsFeedModel> myPosts = [];

  Future<void> getNewsfeed() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id');
    
    try{
      var response = await http.get(
      'https://polar-plains-75515.herokuapp.com/api/user/loggeduser/$id',
      );
      //print(response.body);
    var jsonDataTemp = json.decode(response.body);


    Map data ={
	    'myfollowing': jsonDataTemp['following']
    };
    //encode map to json
    var body = json.encode(data);
    var res = await http.post(
      'https://polar-plains-75515.herokuapp.com/api/newsfeed',
      headers: {"Content-Type": "application/json"},
      body: body
    );
    //print(res.body);
    var jsonData = json.decode(res.body);

    jsonData.forEach((element) {
      NewsFeedModel newsfeed = NewsFeedModel(
        id: element['_id'],
        imageName: element['imageName'],
        description: element['description'],
        ownerid: element['ownerid'],
        ownername: element['ownername'],
        imagedata: element['imageData']
    );

    newsFeed.add(newsfeed);
    
    });
    
    }catch(e){
      print(e);
    }

  }

  Future<void> getMyPosts() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var id = pref.getString('id');

    try{

      var response = await http.get(
        'https://polar-plains-75515.herokuapp.com/api/myposts/$id',
        );

      //print(response.body);
      var jsonData = json.decode(response.body);

      jsonData.forEach((element) {
      NewsFeedModel mypost = NewsFeedModel(
        id: element['_id'],
        imageName: element['imageName'],
        description: element['description'],
        ownerid: element['ownerid'],
        ownername: element['ownername'],
        imagedata: element['imageData']
      );

      myPosts.add(mypost);
    
      });

      //print(myPosts);

    }catch(e){
      print(e);
    }
  }

  Future<void> postPost(var description, var imageName, var imageData ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    try{

      Map data = {
        'description': description,
        'ownerid': pref.getString('id'),
        'ownername': pref.getString('name'),
        'imageName': imageName,
        'imageData': imageData
      };
      //encode map to json
      var body = json.encode(data);

      var response = await http.post(
        'https://polar-plains-75515.herokuapp.com/api/update/${pref.getString('id')}',
        headers: {"Content-Type": "application/json"},
        body: body
      );

      print(response.body);

    }catch(e){

    }

  }
}