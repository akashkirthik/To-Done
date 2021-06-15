import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_done_flutter/models/Task.dart';
import 'package:to_done_flutter/services/DBHelper.dart';
import 'package:to_done_flutter/widgets/TaskTile.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'AddTaskScreen.dart';

class TasksScreen extends StatefulWidget {
  static String id = 'TaskScreen';

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var numTasks;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlueAccent,
          child: Icon(Icons.add),
          onPressed: () {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: Container(
                      child: AddTaskScreen(
                        callback: () {
                          setState(() {
                            numTasks += 1;
                          });
                        },
                      ),
                    )));
          }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                    color: Colors.lightBlueAccent,
                  ),
                  backgroundColor: Colors.white,
                  radius: 30.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'To-Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  numTasks == null ? '' : '$numTasks Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: FutureBuilder(
                future: DBProvider.db.getAllTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    numTasks = snapshot.data.length;
                    List<Task> tasks = snapshot.data;
                    return ListView.builder(
                        itemBuilder: (context, index) {
                          final task = tasks[index];
                          return TaskTile(
                            taskTitle: task.name,
                            isChecked: task.isDone,
                            checkboxCallback: (checkboxState) {
                              DBProvider.db.updateTaskStatus(task, checkboxState);
                              setState(() {});
                            },
                            longPressCallback: () {
                              DBProvider.db.deleteTask(task);
                              setState(() {
                                numTasks -= 1;
                              });
                            },
                          );
                        },
                        itemCount: snapshot.data.length //taskData.taskCount,
                        );
                  } else {
                    return SpinKitFadingCircle(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.white : Colors.blueAccent,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
