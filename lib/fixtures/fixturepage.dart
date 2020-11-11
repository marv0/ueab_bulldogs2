import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'fixturemodel.dart';

class FixturePage extends StatefulWidget {
  FixturePage({Key key,})
      : super(key: key);

  

  @override
  State<StatefulWidget> createState() => new _FixturePageState();
}

class _FixturePageState extends State<FixturePage> {
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  //bool _isEmailVerified = false;

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    _todoList = new List();
    _todoQuery = _database
        .reference()
        .child("todo");
       
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
  }



  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] =
          Todo.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Todo.fromSnapshot(event.snapshot));
    });
  }



  addNewTodo(String todoItem) {
    if (todoItem.length > 0) {
      Todo todo = new Todo(todoItem.toString(), false);
      _database.reference().child("todo").push().set(todo.toJson());
    }
  }

  updateTodo(Todo todo) {
    //Toggle completed
    todo.completed = !todo.completed;
    if (todo != null) {
      _database.reference().child("todo").child(todo.key).set(todo.toJson());
    }
  }

  deleteTodo(String todoId, int index) {
    _database.reference().child("todo").child(todoId).remove().then((_) {
      print("Delete $todoId successful");
      setState(() {
        _todoList.removeAt(index);
      });
    });
  }

  showAddTodoDialog(BuildContext context) async {
    _textEditingController.clear();
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new Row(
              children: <Widget>[
                new Expanded(
                    child: new TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _textEditingController,
                      autofocus: true,
                      decoration: new InputDecoration(
                        labelText: 'Add new fixture',
                      ),
                    ))
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              new FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    addNewTodo(_textEditingController.text.toString());
                    Navigator.pop(context);
                  })
            ],
          );
        });
  }

  Widget showTodoList() {
    if (_todoList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _todoList.length,
          itemBuilder: (BuildContext context, int index) {
            String todoId = _todoList[index].key;
            String subject = _todoList[index].subject;
            bool completed = _todoList[index].completed;
           


              return Container(

//                decoration: new BoxDecoration(
//                  //gradient: LinearGradient(colors: [Colors.black, Colors.black]),
//                  boxShadow: [
//                new BoxShadow(
//                  color: Colors.black,
//                  blurRadius: 20.0,
//                ),
//              ]),

                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20,),
                      Card(color: Colors.white,
                        elevation: 50,
                        child: ListTile(
                          leading: Image.asset("assets/bball.png"),

                          title: Text(
                            subject,
                              style: GoogleFonts.oswald (fontWeight: FontWeight.bold,
                                  fontSize: 20.0, color: Colors.black),
                          ),
                          trailing: IconButton(
                              icon: (completed)
                                  ? Icon(
                                Icons.done_outline,
                                color: Colors.red,
                                size: 20.0,
                              )
                                  : Icon(Icons.done, color: Colors.grey, size: 20.0),
                              onPressed: () {
                              }),

                        ),
                      ),
                     SizedBox(height: 10,)
                    ],
                  ),


              );




          });

    } else {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Colors.black
            //Theme.ofontext).primaryColor, // Red
          ),
        ),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(backgroundColor: Colors.white,
        appBar: new AppBar(backgroundColor: Colors.indigo,
          title: new Text('UPCOMING FIXTURES'  ,style: GoogleFonts.oswald (fontSize: 20.0   , color: Colors.black
          ),),
          centerTitle: true,
          actions: <Widget>[

          ],
        ),

        body: showTodoList(),



    );
  }
}