import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:to_done_flutter/models/Task.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TaskDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE tasks ("
          "taskTitle TEXT,"
          "isDone BIT"
          ")");
    });
  }

  newTask(Task newTask) async {
    final db = await database;
    String name = newTask.name;
    bool isDone = newTask.isDone;
    var res = await db.rawInsert('INSERT INTO tasks(taskTitle,isDone) VALUES("$name",$isDone)');
    print('inserted to table values');
    return res;
  }

  getAllTasks() async {
    print('getting tasks');
    final db = await database;
    var res = await db.query("tasks");
    List<Task> tasks = [];
    for (int i = 0; i < res.length; i++) {
      bool isDoneBool = res[i]['isDone'] == 0 ? false : true;
      tasks.add(Task(name: res[i]['taskTitle'], isDone: isDoneBool));
    }

    return tasks;
  }

  deleteTask(Task delTask) async {
    print('delete called');
    final db = await database;
    db.delete("tasks", where: "taskTitle = ?", whereArgs: [delTask.name]);
  }

  updateTaskStatus(Task task, checkboxState) async {
    print('updating task status');
    final db = await database;
    String name = task.name;
    String query = "UPDATE tasks set isDone =$checkboxState where taskTitle='$name'";
    db.execute(query);
  }
}
