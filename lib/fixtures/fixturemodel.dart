import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String subject;

  bool completed;


  Todo(this.subject,  this.completed);

  Todo.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,

        subject = snapshot.value["subject"],
        completed = snapshot.value["completed"];

  toJson() {
    return {

      "subject": subject,
      "completed": completed,
    };
  }
}