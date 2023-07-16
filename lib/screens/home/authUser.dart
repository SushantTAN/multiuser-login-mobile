
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multiuser_login/models/newsfeedModel.dart';
import 'package:multiuser_login/models/userModel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:multiuser_login/helper/user_helper.dart';
import 'package:multiuser_login/shared/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthUser extends StatefulWidget {

  final UserModel loggeduser1;
  final List<NewsFeedModel> newsFeed1;

  AuthUser({ this.loggeduser1, this.newsFeed1 });

  @override
  _AuthUserState createState() => _AuthUserState();
}

class _AuthUserState extends State<AuthUser> {

  UserModel loggeduser1;
  String loggedname;
  List<NewsFeedModel> newsFeed1;

  var description;
  File sampleImage;

  bool loading = false;




  // getLoggedUser() async {
    
  //   User newUser = User();
  //   await newUser.getUser();

  //   setState(() {
  //     loggeduser1 = newUser.loggedUser;
  //   });
  // }

  // getNewsfeed() async {
  //   SharedPreferences pref = await SharedPreferences.getInstance();
  //   setState(() {
  //     loggedname = pref.getString("name");
  //   });
    
  //   BasicUserData newClass = BasicUserData();
  //   await newClass.getNewsfeed();
    
  //   setState(() {
  //     newsFeed1 = newClass.newsFeed;
      
  //   });
  //   //print(newsFeed[0].description);
  // }



  Future getImage()async{
    var tempImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      sampleImage = tempImage;
    });
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   getLoggedUser();
  //   getNewsfeed();
  // }
  

  @override
  Widget build(BuildContext context) {
    return widget.newsFeed1.length == null ? Loading() : Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: SingleChildScrollView(
                    child: Column(
              children: <Widget>[
                 
                SizedBox(height: 20,),
                Text("Hello ${widget.loggeduser1.name}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),

                SizedBox(height: 10),

                //Make a post
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Form(
                      child: Column(
                        children: <Widget>[

                          Text("Describe your post"),

                          SizedBox(height: 10),

                          Text("Caption"),
                          TextFormField(
                            onChanged: (val){
                              setState(() {
                                description = val;
                              });
                            },
                          ),
                          
                          SizedBox(height: 10),

                          Row(children: <Widget>[
                            Text("Photo"),

                            sampleImage == null ? Text("Img") : enableUpload(),

                            FlatButton(
                              onPressed: (){
                                getImage();
                              },
                              child: Text("Add image"),
                            ),

                            ],
                          ),

                          SizedBox(height: 10),

                          RaisedButton(
                            onPressed: () async {
                              var currentImageName = "firebase-image-${DateTime.now().toString()}";
                              final StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child('multiuser/$currentImageName');
                              final StorageUploadTask task = firebaseStorageRef.putFile(sampleImage);
                              final StorageTaskSnapshot downloadUrl = await task.onComplete;
                              final String url = (await downloadUrl.ref.getDownloadURL());
                              print('URL Is $url');
                              
                              BasicUserData newClass = BasicUserData();
                              await newClass.postPost(description, currentImageName, url);
                              
                            },
                            child: Text("Post"),

                          ),

                        ],
                      ),
                      ),
                  ),
                  ),

                  //News Feed
                  Container(
                    child: ListView.builder(
                      itemCount: widget.newsFeed1.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            NewsFeedTile(
                              name: widget.newsFeed1[index].ownername,
                              description: widget.newsFeed1[index].description,
                              imagedata: widget.newsFeed1[index].imagedata,
                            ),
                            SizedBox(height: 5),
                          ],
                        );
                      }
                      ),
                  ),
              ],
            ),
          ),
        ),
      );
  }

  Widget enableUpload(){
    return Container(
      child: Column(
        children: <Widget>[
          Image.file(sampleImage, height: 300,),
        ],
        ),
    );
  }
}

class NewsFeedTile extends StatelessWidget {

  final String name, description, imagedata;
  NewsFeedTile({ this.name, this.description, this.imagedata });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            Text(
              "$name",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),

            Text(description),

            SizedBox(height: 5),

            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(imagedata),
              ),
          ],
        ),
      ),
    );
  }
}