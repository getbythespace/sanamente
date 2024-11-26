import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> guardarUsuario(Map<String, dynamic> data, String uid) async {
    await _db.collection('users').doc(uid).set(data);
  }

  Future<void> guardarEncuesta(Map<String, dynamic> data) async {
    await _db.collection('encuestas').add(data);
  }
}
