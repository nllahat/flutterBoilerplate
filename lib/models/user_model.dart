import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

enum Gender { Female, Male, Other }

class User {
  final String id;
  final Gender gender;
  final DateTime birthDate;

  User({@required this.id, @required this.gender, @required this.birthDate});

  String getGenderString() {
    String stringGender;

    switch (gender) {
      case Gender.Female:
        stringGender = "female";
        break;
      case Gender.Male:
        stringGender = "male";
        break;
      case Gender.Other:
        stringGender = "else";
        break;
      default:
        stringGender = "else";
    }

    return stringGender;
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "gender": getGenderString(), "birthDate": birthDate};
  }

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    Gender gender;
    Timestamp birthDate = data["birthDate"];

    switch (data["gender"]) {
      case "female":
        gender = Gender.Female;
        break;
      case "male":
        gender = Gender.Male;
        break;
      case "else":
        gender = Gender.Other;
        break;
      default:
    }

    return User(
      id: doc.documentID,
      gender: gender,
      birthDate: birthDate.toDate(),
    );
  }
}
