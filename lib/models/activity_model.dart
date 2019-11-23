import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Activity {
  final String id;
  final String name;
  final String generalDescription;
  final String address;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> coordinators;
  final String image;
  final String organization;

  Activity(
      {@required this.id,
      @required this.name,
      @required this.generalDescription,
      @required this.address,
      @required this.isActive,
      @required this.startDate,
      @required this.endDate,
      @required this.coordinators,
      @required this.image,
      @required this.organization});

  Map<String, dynamic> toJson() => {
        "name": name,
        "generalDescription": generalDescription,
        "address": address,
        "isActive": isActive,
        "startDate": startDate,
        "endDate": endDate,
        "coordinators": coordinators,
        "image": image,
        "organization": organization
      };

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<DocumentReference> coordinatoresDocRef =
        new List<DocumentReference>.from(data['coordinators']);
    DocumentReference organizationRef = data['organization'];
    Timestamp startDate = data['startDate'];
    Timestamp endDate = data['endDate'];

    return Activity(
        id: doc.documentID,
        name: data['name'] ?? '',
        generalDescription: data['generalDescription'] ?? '',
        address: data['address'],
        isActive: data['isActive'] ?? false,
        startDate: startDate.toDate(),
        endDate: endDate.toDate(),
        coordinators:
            coordinatoresDocRef.map((elem) => elem.documentID).toList(),
        image: data['image'] ?? '',
        organization: organizationRef.documentID);
  }
}
