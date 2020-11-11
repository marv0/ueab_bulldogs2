
import 'package:google_fonts/google_fonts.dart';
import 'package:basketball/events/event.dart';
import 'package:basketball/newsfeed/feed.dart';
import 'package:basketball/players/players.dart';
import 'package:basketball/table_standings/standings.dart';
import 'package:basketball/fixtures_dashboard.dart';
import 'package:flutter/material.dart';

import 'auth.dart';
import 'fixtures/fixturepage.dart';
import 'screens/home_screen.dart';



class FirstPage extends StatefulWidget {

  final AuthImplementation auth;
  final VoidCallback onSignedOut;
  FirstPage({
    this.auth,
    this.onSignedOut,
  });
  @override
  _FirstPageState createState() => new _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar (
        title: Text(
          "BULLDOGS BASKETBALL",
          style:  GoogleFonts.oswald (
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              letterSpacing: 1.5),
        ),
        centerTitle: true,
        elevation: 5,
        //centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(

          children: <Widget>[

            //SizedBox(height: 50,),
            HomeScreeTopPart(),
            //SizedBox(height: 20,),
            HomeScreenTopPart(),
            HomeScreenMiddlePart()
          ],
        ),
      ),
      bottomNavigationBar: Container(


        height: 56,
        margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
        child: Row(
          children: <Widget>[

            Expanded(
              child: InkWell(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FixturePage()),
                );
              },
                child: Container(

                  width: 100,
                  color: Colors.indigo,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Icon(Icons.list, color: Colors.black), Text("Fixtures", style: GoogleFonts.oswald (color: Colors.black, fontSize: 18))],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell( onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScoresPage()),
                );
              },
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black,
                  child: Column(
                    children: <Widget>[Icon(Icons.score, color: Colors.indigo),
                      Text("Scores", style: GoogleFonts.oswald (color: Colors.indigo, fontSize: 18)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class HomeScreeTopPart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 230.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: Mclipper(),
            child: Container(
              height: 230.0,
              width: 500,
              decoration: BoxDecoration( gradient: LinearGradient(colors: [Colors.white, Colors.black]),boxShadow: [
                //gradient: LinearGradient(colors: [Colors.white, Colors.black]),
                BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ]),
              child: Stack(
                children: <Widget>[
                  Image.asset("assets/bulldog.png",
                      height: 300,
                      cacheWidth: 400,
                      fit: BoxFit.contain, width: double.infinity),
                  Container(
                    height: 300,
                    width: 300,
//                    decoration: BoxDecoration(
//                        gradient: LinearGradient(
//                            colors: [
//                              const Color(0x00000000),
//                              const Color(0xFF000000)
//                            ],
//                            stops: [
//                              0.0,
//                              0.9
//                            ],
//                            //begin: FractionalOffset(0.0, 0.0),
//                            //end: FractionalOffset(0.0, 1.0))),
//
//                  )
//                    )
                  )],
              ),
            ),
          ),
          Positioned(
            top: 200.0,
            right: -20.0,
            child: FractionalTranslation(
              translation: Offset(0.0, -0.5),
              child: Row(
                children: <Widget>[
//                  FloatingActionButton(
//                    backgroundColor: Colors.white,
//                    onPressed: () {},
//                    child: Icon(
//                      Icons.add,
//                      color: Color(0xFFE52020),
//                    ),
//                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreenTopPart extends StatefulWidget {
  HomeScreenTopPart();



  @override
  _HomeScreenTopPartState createState() => _HomeScreenTopPartState();
}

class _HomeScreenTopPartState extends State<HomeScreenTopPart> {


  @override
  List<String> images = [
    "assets/players.png",
    "assets/events.png",

  ];

  List<String> titles = ["PLAYERS", "EVENTS"];

  List<Widget> activity() {
    List<Widget> activityList = new List();

    for (int i = 0; i < 2; i++) {
      var activityitem = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: SingleChildScrollView(
          child: Container(
            height: 149.0,
            width: 149.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(colors: [Colors.black, Colors.black]),
               ),
            child: Card(color: Colors.white,
elevation: 2,
              child: Column(
                children: <Widget>[
                  //new GestureDetector(onTap: (){},),
                  InkWell(
                    onTap: () {
                      if(i == 0){Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlayerPage()),
                      );

                      }else{Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EventPage()),
                      );

                      }
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      child: Center(
                        child: Image.asset(
                          images[i],
                          width: 70,
                          height: 120.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
                    child: Text(titles[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald ( fontWeight: FontWeight.bold,
                          fontSize: 12.0, color: Colors.black),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                  )
                ],
              ),
            ),
          ),
        ),
      );
      activityList.add(activityitem);
    }
    return activityList;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 200.0,
        margin: EdgeInsets.only(left: 33.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: activity(),
                  //new GestureDetector(onTap: (){}
                ),

              ),


            ]
        )
    );
  }
}

class HomeScreenMiddlePart extends StatefulWidget {
  @override
  _HomeScreenMiddlePartState createState() => _HomeScreenMiddlePartState();
}

class _HomeScreenMiddlePartState extends State<HomeScreenMiddlePart> {


  @override
  List<String> images = [
    "assets/news.png",
    "assets/table.png",

  ];

  List<String> titles = ["NEWS", "NBA NEWS"];

  List<Widget> activity() {
    List<Widget> activityList = new List();

    for (int i = 0; i < 2; i++) {
      var activityitem = Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 5.0),
        child: SingleChildScrollView(
          child: Container(
            height: 149.0,
            width: 149.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(colors: [Colors.black, Colors.black]),
               ),
            child: Card(color: Colors.white,
             elevation: 2,
              child: Column(
                children: <Widget>[
                  //new GestureDetector(onTap: (){},),
                  InkWell(
                    onTap: () {
                      if(i == 0){Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Feed()),
                      );

                      }else{Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );

                      }
                    },

                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      child: Center(
                        child: Image.asset(
                          images[i],
                          width: 70,
                          height: 120.0,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
                    child: Text(titles[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.oswald ( fontWeight: FontWeight.bold,
                          fontSize: 12.0, color: Colors.black),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3.0),
                  )
                ],
              ),
            ),
          ),
        ),
      );
      activityList.add(activityitem);
    }
    return activityList;
  }
  @override
  Widget build(BuildContext context) {
    return new Container(
        height: 200.0,
        margin: EdgeInsets.only(left: 33.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 200.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: activity(),
                  //new GestureDetector(onTap: (){}
                ),

              ),
            ]
        )
    );
  }
}



class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 100.0);

    var controlpoint = Offset(35.0, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}