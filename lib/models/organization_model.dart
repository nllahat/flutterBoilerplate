import 'package:cloud_firestore/cloud_firestore.dart';

class Organization {
  final String id;
  final String name;
  final List<String> managers;

  Organization({this.id, this.name, this.managers});

  Map<String, dynamic> toJson() => {"name": name, "managers": managers};

  factory Organization.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<DocumentReference> managersDocRef = data["managers"] == null ? null :
        new List<DocumentReference>.from(data["managers"]);

    return Organization(
        id: doc.documentID,
        name: data["name"] ?? "",
        managers: managersDocRef?.map((elem) => elem.documentID)?.toList());
  }
}
