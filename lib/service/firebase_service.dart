import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager/model/task_model.dart';

class FirebaseService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<String> addTask(Task task) async {
    try {
      final docRef = await _tasksCollection.add(task.toMap());
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add task: $e');
    }
  }

  Future<List<Task>> getTasks() async {
    try {
      final snapshot = await _tasksCollection.get();
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get tasks: $e');
    }
  }
}
