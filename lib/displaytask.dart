import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud/updatetask.dart';

import 'addtask.dart';

class DisplayTask extends StatefulWidget {
  const DisplayTask({super.key});

  @override
  State<DisplayTask> createState() => _DisplayTaskState();
}

class _DisplayTaskState extends State<DisplayTask> {
  final CollectionReference task =
  FirebaseFirestore.instance.collection('tasks');

  Future<void> deleteTask(String taskId) async {
    await task.doc(taskId).delete();
  }

  void navigateToAddTask() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const AddTask(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text("Flutter CRUD Operation"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: navigateToAddTask,
        label: const Text("Add task"),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: task.orderBy('timestamp').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Loading indicator while waiting for data
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Error message if there's an issue with the data stream
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            // Placeholder or message when there is no data
            return const Center(
              child: Text('No tasks available.'),
            );
          } else {
            // Display the list of tasks
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot taskSnap = snapshot.data!.docs[index];
                final String taskId = taskSnap.id;

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.yellow[200],
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${taskSnap['content']}'),
                          subtitle: Text('${taskSnap['timestamp']}'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) {
                                    return UpdateTask(
                                      content: taskSnap['content'],
                                      timestamp: taskSnap['timestamp'].toString(),
                                      id: taskSnap.id,
                                    );
                                  },
                                ));

                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.teal,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await deleteTask(taskId);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
