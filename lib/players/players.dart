import 'dart:io';
import 'package:basketball/players/playerpost.dart';
import 'package:flutter/material.dart';
import 'package:basketball/players/playerupload.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:basketball/auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class PlayerPage extends StatefulWidget {
  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  PlayerPage({
    this.auth,
    this.onSignedOut,
  });
  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  List<PlayerPost> playerpostList = [];
  File _image;
  DatabaseReference playerpostRef =
  FirebaseDatabase.instance.reference().child("players");

  @override
  void initState() {
    super.initState();
    refreshPlayerPosts();
  }

  void logOutUser() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("error :" + e.toString());
    }
  }

  void refreshPlayerPosts() {
    playerpostRef.once().then((DataSnapshot snap) {
      var playerpostKeys = snap.value.keys;
      var playerpostData = snap.value;

      playerpostList.clear();

      for (var playerpostKey in playerpostKeys) {
        print("Key : " + playerpostKey);
        PlayerPost playerposts = PlayerPost(
          playerpostData[playerpostKey]['picture'],
          playerpostData[playerpostKey]['description'],
          playerpostData[playerpostKey]['description2'],
          playerpostData[playerpostKey]['description3'],
          playerpostData[playerpostKey]['description4'],
          playerpostData[playerpostKey]['description5'],
          playerpostData[playerpostKey]['date'],
          playerpostData[playerpostKey]['time'],
          playerpostKey.toString(),
        );

        playerpostList.add(playerposts);

        setState(() {
          print('Refreshed Length : $playerpostList.length');
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
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: textEditingController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Enter Player Name:',
                      ),
                    )
                )
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

  void updatePlayerPost(PlayerPost playerpost, int index) async {
    String descriptionEdited = await getDescriptionEdited(playerpost.description);
    if (descriptionEdited != null) {
      playerpost.description = descriptionEdited;
    }
    playerpostRef.child(playerpost.playerpostKey).update(playerpost.toJson()).then((_) {
      print("Updated Post with ID : " + playerpost.playerpostKey);
      setState(() {
        playerpostList[index].description = playerpost.description;
      });
    });
  }

  void deletePlayerPost(PlayerPost playerpost, int index) {
    playerpostRef.child(playerpost.playerpostKey).remove().then((_) {
      print("Deleted Post with ID : " + playerpost.playerpostKey);
      setState(() {
        playerpostList.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "TEAM ROSTER",
          style: GoogleFonts.oswald(
              color: Colors.black,
              letterSpacing: 1.5),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Container(
        child: playerpostList.length == 0
            ? Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                Colors.black
              //Theme.ofontext).primaryColor, // Red
            ),
          ),

        )
            : ListView.builder(
          itemCount: playerpostList.length,
          itemBuilder: (_, index) {
            return playerpostCard(playerpostList[index], index);
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.indigo, Colors.black]),
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

  Widget playerpostCard(PlayerPost playerpost, int index) {
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
//                  playerpost.date,
//                  textAlign: TextAlign.center,
//                  style: Theme.of(context).textTheme.subtitle,
//                ),
//                Text(
//                  playerpost.time,
//                  textAlign: TextAlign.center,
//                  style: Theme.of(context).textTheme.subtitle,
//                ),
                SizedBox(width: 100,),

              ],
            ),

            SingleChildScrollView( scrollDirection: Axis.horizontal,
              child: Container(
                child: new Row(
                  children: <Widget>[
                    Image.network(
                      playerpost.playerimage,
                      fit: BoxFit.cover,
                      height: 100,
                      width: 100,
                    ),
                    SizedBox(width: 20,),

                    new Column(
                      children: [

                        new Row(
                          children: [
                            Text("NAME:",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 20,),
                            Text(playerpost.description,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                              ),),
                          ],
                        ),
                        new Row(
                          children: [
                            Text("AGE:",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 20,),
                            Text(playerpost.description2,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                              ),),
                          ],
                        ),
                        new Row(
                          children: [
                            Text("HEIGHT:",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 20,),
                            Text(playerpost.description3,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                              ),),
                          ],
                        ),
                        new Row(
                          children: [
                            Text("WEIGHT:",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 20,),
                            Text(playerpost.description4,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                              ),),
                          ],
                        ),
                        new Row(
                          children: [
                            Text("POSITION:",
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),),
                            SizedBox(width: 20,),
                            Text(playerpost.description5,
                              textAlign: TextAlign.start,
                              style: GoogleFonts.oswald (
                                color: Colors.black,
                              ),),
                          ],
                        ),

                      ],

                    )


                  ],
                ),

color: Colors.white,
              ),

            ),


          ],
        ),
      ),
    );
  }
}
