import 'dart:io';
import 'package:basketball/events/eventpost.dart';
import 'package:flutter/material.dart';
import 'package:basketball/events/eventupload.dart';
import 'package:firebase_database/firebase_database.dart';
import '../auth.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:image_picker/image_picker.dart';

class EventPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  EventPage({
    this.auth,
    this.onSignedOut,
  });
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  List<EventPost> eventpostList = [];
  File _image;
  DatabaseReference eventpostRef =
  FirebaseDatabase.instance.reference().child("events");

  @override
  void initState() {
    super.initState();
    refreshEventPosts();
  }

  void logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("error :" + e.toString());
    }
  }

  void refreshEventPosts() {
    eventpostRef.once().then((DataSnapshot snap) {
      var eventpostKeys = snap.value.keys;
      var eventpostData = snap.value;

      eventpostList.clear();

      for (var eventpostKey in eventpostKeys) {
        print("Key : " + eventpostKey);
        EventPost eventposts = EventPost(
          eventpostData[eventpostKey]['picture'],
          eventpostData[eventpostKey]['description'],
          eventpostData[eventpostKey]['date'],
          eventpostData[eventpostKey]['time'],
          eventpostKey.toString(),
        );

        eventpostList.add(eventposts);

        setState(() {
          print('Refreshed Length : $eventpostList.length');
        });
      }
    });
  }

  Future getDescriptionEdited(String description) async {
    TextEditingController textEditingController =
    TextEditingController(text: description);
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
                    description = textEditingController.text.toString();
                    Navigator.pop(context);
                  })
            ],
          );
        });

    return description;
  }

  void updateEventPost(EventPost eventpost, int index) async {
    String descriptionEdited = await getDescriptionEdited(eventpost.description);
    if (descriptionEdited != null) {
      eventpost.description = descriptionEdited;
    }
    eventpostRef.child(eventpost.eventpostKey).update(eventpost.toJson()).then((_) {
      print("Updated Post with ID : " + eventpost.eventpostKey);
      setState(() {
        eventpostList[index].description = eventpost.description;
      });
    });
  }

  void deleteEventPost(EventPost eventpost, int index) {
    eventpostRef.child(eventpost.eventpostKey).remove().then((_) {
      print("Deleted Post with ID : " + eventpost.eventpostKey);
      setState(() {
        eventpostList.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "UPCOMING EVENTS",
          style: GoogleFonts.oswald (
              color: Colors.black,
              letterSpacing: 1.5),
        ),
        elevation: 5,
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: eventpostList.length == 0
            ? Center(

        child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black
          //Theme.ofontext).primaryColor, // Red
        ),
      ),

        )
            : ListView.builder(
          itemCount: eventpostList.length,
          itemBuilder: (_, index) {
            return eventpostCard(eventpostList[index], index);
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

  Widget eventpostCard(EventPost eventpost, int index) {
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
//                Text(
//                  eventpost.date,
//                  textAlign: TextAlign.center,
//                  style: Theme.of(context).textTheme.subtitle,
//                ),
//                Text(
//                  eventpost.time,
//                  textAlign: TextAlign.center,
//                  style: Theme.of(context).textTheme.subtitle,

//                ),
              SizedBox(width: 100,),

              ],
            ),
            SizedBox(
              height: 10,
            ),
            Image.network(
              eventpost.eventimage,
              fit: BoxFit.fill,
              height: 500,
              width: 300,
            ),
            SizedBox(height: 10,),
            new Row(
              children: <Widget>[
                SizedBox(width: 10,),
                Text("EVENT NAME:", textAlign: TextAlign.center,
                  style: GoogleFonts.oswald (fontWeight: FontWeight.bold,
                  fontSize: 18.0, color: Colors.black),),
                SizedBox(width: 5,),
                Text(
                  eventpost.description,
                  textAlign: TextAlign.center,
                  // set some style to text
                  style: GoogleFonts.oswald (fontSize: 18.0, color: Colors.black),
                ),
              ]),

          ],
        ),
      ),
    );
  }
}
