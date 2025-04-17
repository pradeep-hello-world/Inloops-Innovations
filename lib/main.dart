import 'dart:convert';
import 'Data.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TaskScreen.dart';

void main() {
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoScreen(),
    );
  }
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  void initState() {
    super.initState();
    loadTasks();
  }
  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedTasks = prefs.getString('tasks');
    if (storedTasks != null) {
      setState(() {
        taskdata.tasks = List<Map<String, dynamic>>.from(jsonDecode(storedTasks));
      });
    }
  }

  void toggleTaskCompletion(int index) {
    setState(() {
      taskdata.tasks[index]["completed"] = !taskdata.tasks[index]["completed"];
    });
    taskdata.saveTasks();
  }

  void deleteTask(int index) {
    if (!taskdata.tasks[index]["completed"]) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Confirm Deletion"),
          content: const Text("Are you sure you want to delete this task?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  taskdata.tasks.removeAt(index);
                });
                taskdata.saveTasks();
                Navigator.pop(context);
              },
              child: const Text("Delete"),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        taskdata.tasks.removeAt(index);
      });
      taskdata.saveTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: taskdata.tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        taskdata.tasks[index]["task"],
                        style: TextStyle(
                          decoration: taskdata.tasks[index]["completed"]
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      subtitle: Text(
                          "${taskdata.tasks[index]["date"]} at ${taskdata.tasks[index]["time"]}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              taskdata.tasks[index]["completed"]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              color: Colors.green,
                            ),
                            onPressed: () => toggleTaskCompletion(index),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const TaskScreen()));
          loadTasks();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
