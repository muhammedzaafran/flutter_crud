import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateTask extends StatefulWidget {
  final String content;
  final String timestamp;
  final String id;

  const UpdateTask(
      {Key? key,
      required this.content,
      required this.timestamp,
      required this.id})
      : super(key: key);

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final updateContentController = TextEditingController();
  final updateTimestampController = TextEditingController();
  final CollectionReference task =
  FirebaseFirestore.instance.collection('tasks');
  void updateTask(String taskId) {
    final data = {
      'content': updateContentController.text,
      'timestamp': updateTimestampController.text,
    };
    task.doc(taskId).update(data).then((value) => Navigator.pop(context));
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateContentController.text = widget.content;
    updateTimestampController.text = widget.timestamp;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("Update Task"),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: updateContentController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Content",
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: updateTimestampController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Timestamp",
            ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.teal),
          ),
          onPressed: () {
            updateTask(widget.id);
          },
          child: const Text(
            "Update",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
