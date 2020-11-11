import 'package:firebase_database/firebase_database.dart';


class Category {

  String _id;
  String _match;
  String _homescores;
  String _awayscores;
  String _start;
  String _stop;
  


  Category.category(this._id,this._match,this._homescores ,this._start   ,this._stop , this._awayscores);

  String get match => _match;
  String get homescores => _homescores;
  String get awayscores => _awayscores;
  String get start => _start;
  String get stop => _stop;
  String get id => _id;

  Category.fromSnapshot(DataSnapshot snapshot) {
    _id = snapshot.key;
    _match = snapshot.value['match'];
    _homescores= snapshot.value['home'];
    _awayscores= snapshot.value['away'];
    _start= snapshot.value['start'];
    _stop= snapshot.value['stop'];

  }

}