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

  String _titlename = "";
  int _taskID = 0;
  @override
  void initState() {
    // TODO: implement initState
    if (widget.task != null) {
      _titlename = widget.task.title;
      _taskID = widget.task.id;
    }
    super.initState();
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
                            onSubmitted: (value) async {
                              if (value != "") {
                                if (widget.task == null) {
                                  Task _newTask = Task(title: value);
                                  print("Creating down");
                                  await _dbhelper.insertTask(_newTask);
                                  print("new task has been created");
                                } else {
                                  print("updating");
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Enter Discription for the title",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 24)),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder(
                    initialData: [],
                    future: _dbhelper.getTodo(_taskID),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {},
                                child: TodoWidget(
                                  text: snapshot.data[index].title,
                                  isDone: snapshot.data[index].isDone == 0
                                      ? false
                                      : true,
                                ),
                              );
                            }),
                      );
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          margin: EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.transparent,
                              border:
                                  Border.all(color: Colors.black, width: 1.5)),
                          child: Image(
                            image: AssetImage("assets/images/check_icon.png"),
                          ),
                        ),
                        Expanded(
                          child: TextField(
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
                  )
                ],
              ),
              Positioned(
                  bottom: 10,
                  right: 24,
                  child: GestureDetector(
                    onTap: () {
                      _dbhelper.deleteTasks(_taskID);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Homepage())).then((value) {
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
                                Color(0xFFffe9bf),
                                Color(0xFFffd280),
                                Color(0xFFffb020),
                              ],
                            ))),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
