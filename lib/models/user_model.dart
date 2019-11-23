import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Gender { Female, Male }

class User {
  final String id;
  final Gender gender;

  User({@required this.id, @required this.gender});

  Map<String, dynamic> toJson() => {"id": id, "gender": gender};

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return User(
      id: doc.documentID,
      gender: data['gender'] == 'female' ? Gender.Female : Gender.Male,
    );
  }
}

