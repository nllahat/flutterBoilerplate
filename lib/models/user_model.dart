import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Gender { Female, Male, Other }
enum Role { Admin, Coordinator, Regular }

class User {
  final String id;
  final Gender gender;
  final DateTime birthDate;
  final Role role;

  User(
      {@required this.id,
      @required this.gender,
      @required this.birthDate,
      @required this.role});

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
        stringGender = "other";
        break;
      default:
        stringGender = "other";
    }

    return stringGender;
  }

  String getRoleString() {
    String stringRole;

    switch (role) {
      case Role.Admin:
        stringRole = "admin";
        break;
      case Role.Coordinator:
        stringRole = "coordinator";
        break;
      case Role.Regular:
        stringRole = "regular";
        break;
      default:
        stringRole = "regular";
    }

    return stringRole;
  }

  static Gender getGenderEnum(String gender) {
    Gender enumGender;

    switch (gender) {
      case "female":
        enumGender = Gender.Female;
        break;
      case "male":
        enumGender = Gender.Male;
        break;
      case "other":
        enumGender = Gender.Other;
        break;
      default:
        enumGender = Gender.Other;
    }

    return enumGender;
  }

  static Role getRoleEnum(String role) {
    Role enumRole;

    switch (role) {
      case "admin":
        enumRole = Role.Admin;
        break;
      case "coordinator":
        enumRole = Role.Coordinator;
        break;
      case "regular":
        enumRole = Role.Regular;
        break;
      default:
        enumRole = Role.Regular;
    }

    return enumRole;
  }

  Map<String, dynamic> toJson() => {
        "gender": getGenderString(),
        "birthDate": birthDate,
        "role": getRoleString()
      };

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    Gender gender = getGenderEnum(data["gender"]);
    Timestamp birthDate = data["birthDate"];
    Role role = getRoleEnum(data["role"]);

    return User(
        id: doc.documentID,
        gender: gender,
        birthDate: birthDate?.toDate(),
        role: role);
  }
}
