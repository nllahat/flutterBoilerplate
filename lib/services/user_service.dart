import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final String uid;
  UserService({ this.uid });

  // collection reference
  final CollectionReference usersDataCollection = Firestore.instance.collection('users_data');

  Future<void> updateUserData(String name) async {
    return await usersDataCollection.document(uid).setData({
      'name': name
    });
  }

  // user data from snapshots
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name']
    );
  }

  // get user doc stream
  Stream<UserData> get userData {
    return usersDataCollection.document(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}