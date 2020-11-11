import 'package:basketball/fixtures.dart';
import 'package:flutter/material.dart';



class AddFixtureDialog {




  final teMatch = TextEditingController();
  final teMatch2 = TextEditingController();
  final teHometeam = TextEditingController();
  final teAwayteam = TextEditingController();
  final teStart_stop = TextEditingController();
  final teQuater = TextEditingController();
  Fixture user;

  static const TextStyle linkStyle = const TextStyle(
    color: Colors.blue,
    decoration: TextDecoration.underline,
  );

  Widget buildAboutDialog(BuildContext context,
      AddFixtureCallback _myHomePageState, bool isEdit, Fixture user) {
    if (user != null) {
      this.user = user;
      teMatch.text = user.match;
      teMatch2.text = user.match;
      teHometeam.text = user.hometeam;
      teAwayteam.text = user.awayteam;
      teQuater.text = user.quater;
    }

    return new AlertDialog(
      title: new Text(isEdit ? 'Edit !' : 'Start!'),
      content: new SingleChildScrollView(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getTextField("Match", teMatch),
            getTextField("Match", teMatch2),
            getTextField("Home Team Score", teHometeam),
            getTextField("Away Team Score", teAwayteam),
            getTextField("Quater", teQuater),



//            new GestureDetector(
//              onTap: () =>addDynamic,
//
//              //=> onTap(isEdit, _myHomePageState, context),
//              child: new Container(
//                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
//                child: getAppBorderButton(isEdit ? "Edit Order" : "Place Order!",
//                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
//              ),
//            ),



            new GestureDetector(
              onTap: () => onTap(isEdit, _myHomePageState, context),
              child: new Container(
                margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                child: getAppBorderButton(isEdit ? "Edit" : "Start!",
                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTextField(

      String inputBoxName, TextEditingController inputBoxController) {
    var loginBtn = new Padding(
      padding: const EdgeInsets.all(5.0),
      child: new TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: inputBoxController,
        decoration: new InputDecoration(
          hintText: inputBoxName,
        ),
      ),
    );

    return loginBtn;
  }

  Widget getAppBorderButton(String buttonLabel, EdgeInsets margin) {
    var loginBtn = new Container(
      margin: margin,
      padding: EdgeInsets.all(8.0),
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        border: Border.all(color: const Color(0xFF28324E)),
        borderRadius: new BorderRadius.all(const Radius.circular(6.0)),
      ),
      child: new Text(
        buttonLabel,
        style: new TextStyle(
          color: const Color(0xFF28324E),
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
    return loginBtn;
  }

  Fixture getData(bool isEdit) {
    return new Fixture(isEdit ? user.id : "", teMatch.text, teMatch2.text, teHometeam.text,
        teAwayteam.text, teQuater.text);
  }

  onTap(bool isEdit, AddFixtureCallback _myHomePageState, BuildContext context) {
    if (isEdit) {
      _myHomePageState.update(getData(isEdit));
      Navigator.of(context).pop();
    } else {
      _myHomePageState.addFixture(getData(isEdit));
      Navigator.of(context).pop();
    }
  }




}

abstract class AddFixtureCallback {
  void addFixture(Fixture fixture);

  void update(Fixture fixture);
}


