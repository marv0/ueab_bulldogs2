import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';



class Fixture {

  String _id;
  String _match;
  String _match2;
  String _home;
  String _away;
  String _quater;

  Fixture(this._id,this._match, this._match2, this._home, this._away, this._quater);

  String get match => _match;

  String get match2 => _match2;

  String get hometeam => _home;

  String get awayteam => _away;

  String get quater => _quater;

  String get id => _id;

  Fixture.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _match = snapshot.value['match'];
    _match2 = snapshot.value['match2'];
    _home = snapshot.value['home'];
    _away = snapshot.value['away'];
    _quater = snapshot.value['quater'];
  }

}




