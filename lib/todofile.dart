// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:task_app/load.dart';
import 'package:task_app/services/dbservices.dart';


import 'module/todoclass.dart';

class Todohome extends StatefulWidget {
  const Todohome({super.key});

  @override
  State<Todohome> createState() => _TodohomeState();
}

class _TodohomeState extends State<Todohome> {
  bool isFinish = false;
  TextEditingController todoTitlerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: StreamBuilder<List<Todo>?>(
              stream: DatabaseService().listTodos(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Loading();
                }
                List<Todo>? Task = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Task List",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(color: Colors.orange),
                      const SizedBox(height: 5),
                      ListView.separated(
                          separatorBuilder: ((context, index) =>
                              const Divider()),
                          shrinkWrap: true,
                          itemCount: Task!.length,
                          itemBuilder: (context, index) {
                            return Dismissible(
                              key: Key(Task[index].title),
                              background: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  alignment: Alignment.centerLeft,
                                  color: Colors.green,
                                  child: const Icon(Icons.delete)),
                              onDismissed: (direction) async {
                                await DatabaseService()
                                    .removeTask(Task[index].uid);
                                // print("Removed");
                              },
                              child: ListTile(
                                onTap: () {
                                  DatabaseService().finishTask(Task[index].uid);
                                },
                                leading: Container(
                                  padding: const EdgeInsets.all(2),
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      shape: BoxShape.circle),
                                  child: Task[index].isFinish
                                      ? const Icon(Icons.check,
                                          color: Colors.white)
                                      : Container(),
                                ),
                                title: Text(
                                  Task[index].title,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          })
                    ],
                  ),
                );
              }),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: Row(
                      children: [
                        const Text("Add to list",
                            style: TextStyle(fontSize: 15)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.cancel,
                              size: 20, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    children: [
                      const Divider(
                        color: Colors.black,
                      ),
                      TextFormField(
                        controller: todoTitlerController,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 1.5,
                        ),
                        autofocus: true,
                        decoration: const InputDecoration(
                            hintText: "add reminder",
                            hintStyle: TextStyle(color: Colors.black),
                            border: InputBorder.none),
                        cursorColor: Colors.black,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                            child: const Text("ADD"),
                            onPressed: () async {
                              if (todoTitlerController.text.isNotEmpty) {
                                //print(todoTitlerController.text);
                                await DatabaseService().createNewTodo(
                                    todoTitlerController.text.trim());
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context, true);
                              }
                            }),
                      )
                    ],
                  );
                });
          },
        ));
  }
}
