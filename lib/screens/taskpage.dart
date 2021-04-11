import 'package:flutter/material.dart';
import 'package:todo_app/database_helper.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/screens/homepage.dart';
import 'package:todo_app/widgets.dart';

class Taskpage extends StatefulWidget {
  final Task task;
  Taskpage({@required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbhelper = DatabaseHelper();
  FocusNode _titlefocus;
  FocusNode _discriptionfocus;
  FocusNode _todofocus;
  bool _contentVisiblity = false;
  bool _isLongPressed = false;
  int longPressId = 0;

  String _titlename = "";
  String _discriptiontitle = "";
  int _taskID = 0;
  @override
  void initState() {
    if (widget.task != null) {
      _contentVisiblity = true;
      _titlename = widget.task.title;
      _taskID = widget.task.id;
      _discriptiontitle = widget.task.discription;
    }
    _titlefocus = FocusNode();
    _discriptionfocus = FocusNode();
    _todofocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titlefocus.dispose();
    _discriptionfocus.dispose();
    _todofocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  "assets/images/back_arrow_icon.png"),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titlefocus,
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  print("Creating down");
                                  _taskID =
                                      await _dbhelper.insertTask(_newTask);
                                  setState(() {
                                    _contentVisiblity = true;
                                    _titlename = value;
                                  });
                                  _discriptionfocus.requestFocus();
                                  print("new task has been created");
                                } else {
                                  _dbhelper.updateTaskTitle(_taskID, value);
                                  print("updated");
                                }
                              }
                            },
                            controller: TextEditingController(text: _titlename),
                            decoration: InputDecoration(
                                hintText: "Enter a task Title",
                                border: InputBorder.none),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisiblity,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: TextField(
                        controller:
                            TextEditingController(text: _discriptiontitle),
                        focusNode: _discriptionfocus,
                        onSubmitted: (value) {
                          if (value != null) {
                            if (_taskID != 0) {
                              _dbhelper.updateDiscriptionTitle(_taskID, value);
                              print("discription updated");
                              _todofocus.requestFocus();
                            }
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Discription for the title",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 24)),
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: _contentVisiblity,
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbhelper.getTodo(_taskID),
                      builder: (context, snapshot) {
                        return Expanded(
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () async {
                                    print(
                                        "todo is done ${snapshot.data[index].isDone}");
                                    if (snapshot.data[index].isDone == 0) {
                                      await _dbhelper.updateTodoDone(
                                          snapshot.data[index].id, 1);
                                    } else {
                                      await _dbhelper.updateTodoDone(
                                          snapshot.data[index].id, 0);
                                    }
                                    setState(() {});
                                  },
                                  onLongPress: () {
                                    longPressId = snapshot.data[index].id;
                                    if (_isLongPressed == true) {
                                      _isLongPressed = false;

                                      print(
                                          "LOng presssed id ++++++++=${snapshot.data[index].id}");
                                    } else {
                                      _isLongPressed = true;
                                      print(
                                          "LOng presssed id ++++++++=${snapshot.data[index].id}");
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TodoWidget(
                                                text:
                                                    snapshot.data[index].title,
                                                isDone: snapshot.data[index]
                                                            .isDone ==
                                                        0
                                                    ? false
                                                    : true,
                                              ),
                                            ),
                                            Container(
                                                padding:
                                                    EdgeInsets.only(right: 20),
                                                child: _isLongPressed &&
                                                        longPressId ==
                                                            snapshot
                                                                .data[index].id
                                                    ? GestureDetector(
                                                        child: Image(
                                                          image: AssetImage(
                                                              'assets/images/delete_icon.png'),
                                                          color: Colors.red,
                                                        ),
                                                        onTap: () async {
                                                          await _dbhelper
                                                              .deleteTodo(
                                                                  longPressId);
                                                          print("Todo deleted");
                                                          _isLongPressed =
                                                              false;
                                                          setState(() {});
                                                        },
                                                      )
                                                    : null)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _contentVisiblity,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Container(
                            height: 20,
                            width: 20,
                            margin: EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                                border: Border.all(
                                    color: Colors.black, width: 1.5)),
                            child: Image(
                              image: AssetImage("assets/images/check_icon.png"),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              controller: TextEditingController()..text = "",
                              focusNode: _todofocus,
                              onSubmitted: (value) async {
                                print("$value");
                                if (value != "") {
                                  if (widget.task != null) {
                                    DatabaseHelper _dbhelper = DatabaseHelper();

                                    Todo _newTodo = Todo(
                                      title: value,
                                      isDone: 0,
                                      taskId: widget.task.id,
                                    );
                                    await _dbhelper.insertTodo(_newTodo);
                                    setState(() {});
                                    _todofocus.requestFocus();
                                    print("new todo has been created");
                                  }
                                }
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Todo item"),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Visibility(
                visible: _contentVisiblity,
                child: Positioned(
                    bottom: 30,
                    right: 24,
                    child: GestureDetector(
                      onTap: () {
                        _dbhelper.deleteTasks(_taskID);
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Homepage()))
                            .then((value) {
                          setState(() {});
                        });
                      },
                      child: Container(
                          width: 60,
                          height: 60,
                          child: Image(
                            image: AssetImage('assets/images/delete_icon.png'),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFfffbd5),
                                  Color(0xFFED213A),
                                ],
                              ))),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
