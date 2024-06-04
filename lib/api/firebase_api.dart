import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

class Response {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? body;

  Response({required this.statusCode, required this.message, this.body});
}

class FirebaseApi {
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  static Future<Response> createAccount(String email, String password, String name, bool wantToBeAuthor) async {
    if (email.isEmpty) {
      return Response(statusCode: 400, message: "Email não pode ser vazio!");
    }

    if (password.isEmpty) {
      return Response(statusCode: 400, message: "Senha não pode ser vazia!");
    }
    if (name.isEmpty) {
      return Response(statusCode: 400, message: "Nome não pode ser vazio!");
    }

    const codec = Utf8Codec();
    final key = codec.encode(password);
    final data = Uint8List.fromList(key);

    String hashedPassword = sha256.convert(data).toString();

    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentReference documentReference = usersCollection.doc(email);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        return Response(statusCode: 400, message: "Email já cadastrado!");
      } else {
        await documentReference.set({
          "email": email,
          "password": hashedPassword,
          "name": name,
          "isAuthor": wantToBeAuthor,
          "tokenMoodo": '',
          "deviceKey": 0,
          "espIpAddress": '',
          "firstLogin": true,
        });
      }
      return Response(statusCode: 200, message: "Conta criada com sucesso!");
    } catch (e) {
      print(e.toString());
      return Response(statusCode: 400, message: e.toString());
    }
  }

  static Future<Response> login(String email, String password) async {
    if (email.isEmpty) {
      return Response(statusCode: 400, message: "Email não pode ser vazio!");
    }

    if (password.isEmpty) {
      return Response(statusCode: 400, message: "Senha não pode ser vazia!");
    }

    const codec = Utf8Codec();
    final key = codec.encode(password);
    final data = Uint8List.fromList(key);

    String hashedPassword = sha256.convert(data).toString();

    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentReference documentReference = usersCollection.doc(email);
      DocumentSnapshot documentSnapshot = await documentReference.get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
        if (data['password'] == hashedPassword) {
          return Response(
            statusCode: 200,
            message: "Login efetuado com sucesso!",
            body: data,
          );
        } else {
          return Response(statusCode: 400, message: "Senha incorreta!");
        }
      } else {
        return Response(statusCode: 400, message: "Email não cadastrado!");
      }
    } catch (e) {
      return Response(statusCode: 400, message: e.toString());
    }
  }

  static Future<Response> settings(String email, Map<String, dynamic> settings) async {
    try {
      final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
      DocumentReference documentReference = usersCollection.doc(email);
      await documentReference.update(settings).timeout(const Duration(seconds: 10));
      return Response(statusCode: 200, message: "Configurações atualizadas com sucesso!");
    } catch (e) {
      return Response(statusCode: 400, message: e.toString());
    }
  }
}
