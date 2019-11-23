import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String id;
  final String name;

  Organization({this.id, this.name});

  Map<String, dynamic> toJson() => {
        "name": name,
      };

  factory Organization.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Organization(id: doc.documentID, name: data['name'] ?? '');
  }
}
