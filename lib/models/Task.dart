class Task {
  final String name;
  bool isDone;

  Task({this.name, this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }

  @override
  String toString() {
    // TODO: implement toString
    print('$name $isDone');
    return super.toString();
  }
}
