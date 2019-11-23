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
}