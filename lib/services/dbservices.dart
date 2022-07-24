import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app/module/todoclass.dart';

class DatabaseService {
  CollectionReference todosCollection =
      FirebaseFirestore.instance.collection("Task");

  Future createNewTodo(String title) async {
    return await todosCollection.add({
      "title": title,
      "isFinish": false,
    });
  }

  Future finishTask(uid) async {
    await todosCollection.doc(uid).update({"isFinish": true});
  }

  Future removeTask(uid) async {
    await todosCollection.doc(uid).delete();
  }

  List<Todo>? todoFromFirestore(QuerySnapshot<Object?> snapshot) {
    // ignore: unnecessary_null_comparison
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return Todo(
          isFinish: (e.data() as dynamic)['isFinish'],
          title: (e.data() as dynamic)['title'],
          uid: e.id,
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>?> listTodos() {
    return todosCollection.snapshots().map(todoFromFirestore);
  }
}
