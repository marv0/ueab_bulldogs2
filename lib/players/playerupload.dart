import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:basketball/players/players.dart';
import 'package:basketball/dialogbox.dart';

class NewPlayerPost extends StatefulWidget {
  final File playerimage;
  NewPlayerPost({Key key, @required this.playerimage}) : super(key: key);

  @override
  _NewPlayerPostState createState() => _NewPlayerPostState(playerimage);
}

class _NewPlayerPostState extends State<NewPlayerPost> {
  File playerimage;
  String _description;
  String _description2;
  String _description3;
  String _description4;
  String _description5;
  String _url;
  DialogBox dialogBox;
  final formKey = GlobalKey<FormState>();

  _NewPlayerPostState(this.playerimage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Post",
          style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(25),
              child: Form(
                  key: formKey,
                  child: Column(children: <Widget>[
                    Image.file(playerimage, height: 175, width: 350),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(labelText: 'Caption'),
                      validator: (value) {
                        return value.isEmpty ? 'Description is required' : null;
                      },
                      onSaved: (value) {
                        return _description = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: uploadImage,
                      child: Container(
                        width: 100,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.cyan, Colors.black]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xFF6078ea).withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0)
                            ]),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              "DONE",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]))),
        ),
      ),
    );
  }

  bool formValidateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void uploadImage() async {
    if (formValidateAndSave()) {
      final StorageReference postImageRef =
      FirebaseStorage.instance.ref().child("post players");
      var timeKey = DateTime.now();
      final StorageUploadTask uploadTask =
      postImageRef.child(timeKey.toString() + ".jpg").putFile(playerimage);
      var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
      _url = imageUrl.toString();
      await saveToDatabase(_url);
      goToPlayerPage();
    }
  }

  Future saveToDatabase(url) async {
    var timeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, yyyy');
    var formatTime = DateFormat('EEEE, hh:mm aaa');

    String date = formatDate.format(timeKey);
    String time = formatTime.format(timeKey);

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    var data = {"picture": _url, "description": _description, "description2": _description2,
      "description3": _description3,
      "description4": _description4,
      "description5": _description5, "date": date, "time": time};

    ref.child("players").push().set(data);
  }

  void goToPlayerPage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => PlayerPage()));
  }
}
