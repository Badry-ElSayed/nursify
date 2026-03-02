import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nursify/BottomNavBar/Tasks/task-model.dart';

class FireBaseDatabaseService {
  FireBaseDatabaseService._internal();
  static final FireBaseDatabaseService instance =
      FireBaseDatabaseService._internal();
  factory FireBaseDatabaseService() => instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserData(String uid, String name, String email) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw "Failed to save user data: $e";
    }
  }

  Future<void> updateUserName(String uid, String newName) async {
    try {
      await _firestore.collection('users').doc(uid).update({'name': newName});
    } catch (e) {
      throw "Failed to update profile name: $e";
    }
  }

  Future<void> addTaskToFirestore({
    required String uid,
    required String title,
    required String patient,
    required String room,
    required String priority,
    required bool isCompleted,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('tasks').add({
        'title': title,
        'patient': patient,
        'room': room,
        'priority': priority,
        'isCompleted': isCompleted,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw "Failed to add task: $e";
    }
  }

  Stream<QuerySnapshot> getTasks(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> deleteTask(String taskID) async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .doc(taskID)
        .delete();
  }

  Future<void> updateTask(TaskModel task) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) throw "User not logged in";

    try {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('tasks')
          .doc(task.taskID)
          .update({
            'title': task.title,
            'patient': task.patient,
            'room': task.room,
            'priority': task.priority,
            'lastUpdate': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw "Failed to update task: $e";
    }
  }

  Future<void> addPatientToFirestore({
    required String uid,
    required String name,
    required String room,
    required String status,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).collection('patients').add({
        'name': name,
        'room': room,
        'status': status,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw "Failed to add patient: $e";
    }
  }

  Future<void> updatePatient({
    required String uid,
    required String patientId,
    required String newName,
    required String newRoom,
    required String newStatus,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('patients')
          .doc(patientId)
          .update({
            'name': newName,
            'room': newRoom,
            'status': newStatus,
            'lastUpdate': FieldValue.serverTimestamp(),
          });
    } catch (e) {
      throw "Failed to update patient: $e";
    }
  }

  Future<void> deletePatient(String uid, String patientId) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('patients')
          .doc(patientId)
          .delete();
    } catch (e) {
      throw "Failed to delete patient: $e";
    }
  }

  Stream<QuerySnapshot> getPatients(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('patients')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
