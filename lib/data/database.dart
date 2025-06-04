import 'package:hive_flutter/hive_flutter.dart';
class ToDoDataBase {
  List toDoList = [];
  final _myBox = Hive.box('mybox');

  //run this function if this is the 2st time ever openeing this app
  void createInitialData(){
    toDoList = [];
  }

  void loadData(){
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDataBase(){
    _myBox.put("TODOLIST", toDoList);
  }

}