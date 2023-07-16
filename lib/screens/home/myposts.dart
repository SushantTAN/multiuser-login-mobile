
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:multiuser_login/models/newsfeedModel.dart';
import 'package:multiuser_login/shared/loading.dart';
import 'package:multiuser_login/helper/user_helper.dart';

class Myposts extends StatefulWidget {

  // final List<NewsFeedModel> myPosts;

  // Myposts({ this.myPosts });

  @override
  _MypostsState createState() => _MypostsState();
}

class _MypostsState extends State<Myposts> {
  List<NewsFeedModel> myPosts;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyposts();
  }

  getMyposts() async {
    
    BasicUserData newClass = BasicUserData();
    await newClass.getMyPosts();

    setState(() {
      myPosts = newClass.myPosts;
    });

    //print(myPosts[0].description);
  }

  @override
  Widget build(BuildContext context) {
    return myPosts.length == null ? Loading() : Container(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: ListView.builder(
        itemCount: myPosts.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
                        children: <Widget>[
                          PostTile(
                            name: myPosts[index].ownername,
                            description: myPosts[index].description,
                            imagedata: myPosts[index].imagedata,
                          ),
                          SizedBox(height: 5),
                        ],
                      );
        }
        ),
    );
  }
}

class PostTile extends StatelessWidget {

  final String name, description, imagedata;
  PostTile({ this.name, this.description, this.imagedata });

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