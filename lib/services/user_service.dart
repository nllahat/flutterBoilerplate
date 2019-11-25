import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  UserService();

  // collection reference
  final CollectionReference usersCollection = Firestore.instance.collection('users');

  Future<User> getUser(String id) async {
    DocumentSnapshot doc = await usersCollection.document(id).get();

    if (doc.exists == false) {
      return null;
    }

    return User.fromFirestore(doc);
  }

  Future<User> addUser(User user) async {
    Map<String, dynamic> jsonMap = user.toJson();

    try {
      DocumentReference docRef = await usersCollection.add(jsonMap);
      print("Document written with ID: ${docRef.documentID}");

      return User.fromFirestore(await docRef.get());
    } catch (e) {
      print("Error adding document: $e");
      throw e;
    }
  }
}