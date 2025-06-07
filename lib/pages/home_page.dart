import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo/data/database.dart';
import 'package:todo/util/navigation_widget.dart';
import 'package:todo/util/todo_tile.dart';
import 'package:todo/util/dialog_box.dart';



class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();
  final _myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState(){
    // if this is the 1st time ever opening the app, then create default data
    if(_myBox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      //data already exist
      db.loadData();
    }
    super.initState();
  }

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }


  void editTask(int index){
    _controller.text = db.toDoList[index][0]; // Pre-fill the text field with the current task name
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: () {
            setState(() {
              db.toDoList[index][0] = _controller.text; // Update the task name
              _controller.clear();
            });
            Navigator.of(context).pop();
            db.updateDataBase();
          },
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void notificationTask(int index){
    showDialog(
      context: context,
        builder: (context) {
        return AlertDialog( // Added missing semicolon
          title: const Text('Notification'),
                backgroundColor: Colors.yellowAccent[100],
                content: NavigationWidget(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "TO DO",
              style: TextStyle(color: Colors.white, fontFamily: ""),
            ),
          ],
        ),
        backgroundColor: Colors.indigoAccent,
      ),
      drawer: Drawer(

        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.indigoAccent, Colors.white],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,

                )

              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Todo", style: TextStyle(fontSize: 40, fontFamily: "Bauhaus 93" ),),
                ]
              ),

            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text("Pomodoro Timer"),
              onTap: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, '/timer');
              },
            ),
          ]
        )

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        backgroundColor: Colors.indigoAccent[100],
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.cyanAccent[100]! ,Colors.yellowAccent[100]!],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: db.toDoList.isEmpty
            ? const Center(
                child: Text(
                  "No Tasks Added Yet, Press + to add",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              )
            : ListView.builder(
                itemCount: db.toDoList.length,
                itemBuilder: (context, index) {
                  return ToDoTile(
                    taskName: db.toDoList[index][0],
                    taskCompleted: db.toDoList[index][1],
                    onChanged: (value) => checkBoxChanged(value, index),
                    deleteFunction: (context) => deleteTask(index),
                    editFunction: (context) => editTask(index),
                    notificationFunction: (context) => notificationTask(index),
                  );
                },
              ),
      ),
    );
  }
}
