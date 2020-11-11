import 'dart:io';
import 'package:basketball/newsfeed/post.dart';
import 'package:flutter/material.dart';
import 'package:basketball/table_standings/standingupload.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

class Standings extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  Standings({
    this.auth,
    this.onSignedOut,
  });
  @override
  _StandingsState createState() => _StandingsState();
}

class _StandingsState extends State<Standings> {
  List<Post> postList = [];
  File _image;
  DatabaseReference postRef =
      FirebaseDatabase.instance.reference().child("standings");

  @override
  void initState() {
    super.initState();
    refreshPosts();
  }

  void logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("error :" + e.toString());
    }
  }

  void refreshPosts() {
    postRef.once().then((DataSnapshot snap) {
      var postKeys = snap.value.keys;
      var postData = snap.value;

      postList.clear();

      for (var postKey in postKeys) {
        print("Key : " + postKey);
        Post posts = Post(
          postData[postKey]['image'],
          postData[postKey]['desc'],
          postData[postKey]['date'],
          postData[postKey]['time'],
          postKey.toString(),
        );

        postList.add(posts);

        setState(() {
          print('Refreshed Length : $postList.length');
        });
      }
    });
  }

  Future getDescEdited(String desc) async {
    TextEditingController textEditingController =
        TextEditingController(text: desc);
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Expanded(
                    child: TextField(
                  controller: textEditingController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Edit Caption',
                  ),
                ))
              ],
            ),
            actions: <Widget>[
              FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              FlatButton(
                  child: Text('Save'),
                  onPressed: () {
                    desc = textEditingController.text.toString();
                    Navigator.pop(context);
                  })
            ],
          );
        });

    return desc;
  }

  void updatePost(Post post, int index) async {
    String descEdited = await getDescEdited(post.desc);
    if (descEdited != null) {
      post.desc = descEdited;
    }
    postRef.child(post.postKey).update(post.toJson()).then((_) {
      print("Updated Post with ID : " + post.postKey);
      setState(() {
        postList[index].desc = post.desc;
      });
    });
  }

  void deletePost(Post post, int index) {
    postRef.child(post.postKey).remove().then((_) {
      print("Deleted Post with ID : " + post.postKey);
      setState(() {
        postList.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TABLE STANDINGS",
          style: GoogleFonts.oswald (
              color: Colors.black,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: postList.length == 0
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black
              //Theme.ofontext).primaryColor, // Red
            ),
          ),
              )
            : ListView.builder(
                itemCount: postList.length,
                itemBuilder: (_, index) {
                  return postCard(postList[index], index);
                },
              ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigo, Colors.indigo]),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),

          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  Widget postCard(Post post, int index) {
    return Card(color: Colors.white,
      elevation: 10,
      margin: EdgeInsets.all(15),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  post.date,
                  textAlign: TextAlign.center,
                  style:  GoogleFonts.oswald (
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  post.time,
                  textAlign: TextAlign.center,
                  style:  GoogleFonts.oswald (
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Image.network(
                post.image,
                fit: BoxFit.cover,
                height: 300,
                width: 600,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              post.desc,
              textAlign: TextAlign.center,
              style:  GoogleFonts.oswald (
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
