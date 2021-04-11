import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/todo.dart';

import 'models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, discription TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT, isDone INTEGER,taskID INTEGER)");
        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskId = value;
    });
    return taskId;
  }

  Future<void> updateTaskTitle(int id, String newtitle) async {
    Database _db = await database();
    _db.rawQuery("UPDATE tasks SET title='$newtitle' where id='$id'");
  }

  Future<void> updateTodoDone(int id, int isDone) async {
    Database _db = await database();
    _db.rawQuery("UPDATE todo SET isDone='$isDone' where id='$id'");
  }

  Future<void> updateDiscriptionTitle(int id, String discription) async {
    Database _db = await database();
    _db.rawQuery("UPDATE tasks SET discription='$discription' where id='$id'");
  }

  Future<void> updateTodoTitle(int id, String title) async {
    Database _db = await database();
    _db.rawQuery("UPDATE tasks SET title='$title' where id='$id'");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          discription: taskMap[index]['discription']);
    });
  }

  Future<void> deleteTasks(int taskid) async {
    Database _db = await database();
    await _db.delete(
      'tasks',
      where: 'id=$taskid',
    );
  }

  Future<void> deleteTodo(int todoid) async {
    Database _db = await database();
    await _db.delete(
      'todo',
      where: 'id=$todoid',
    );
  }

  Future<List<Todo>> getTodo(int taskId) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery('SELECT * FROM todo where taskId =$taskId');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone'],
          taskId: todoMap[index]['taskId']);
    });
  }
}
