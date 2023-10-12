import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Response {
  final int statusCode;
  final String message;

  Response({required this.statusCode, required this.message});
}

class FirebaseApi {
  static void initialize() {
    Firebase.initializeApp();
  }

  static Future<Response> createAccount(String email, String password) async {
    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      await usersCollection.add({
        "email": email,
        "password": password,
      });
      return Response(statusCode: 200, message: "Conta criada com sucesso!");
    } catch (e) {
      return Response(statusCode: 400, message: e.toString());
    }
  }
}
