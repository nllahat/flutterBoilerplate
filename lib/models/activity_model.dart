import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  final String id;
  final String name;
  final String generalDescription;
  final GeoPoint location;
  final bool isActive;
  final DateTime startDate;
  final DateTime endDate;
  final List<String> coordinators;
  final String image;
  final String organisation;

  Activity(
      {this.id,
      this.name,
      this.generalDescription,
      this.location,
      this.isActive,
      this.startDate,
      this.endDate,
      this.coordinators,
      this.image,
      this.organisation});

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "generalDescription": generalDescription,
        "location": location,
        "isActive": isActive,
        "startDate": startDate,
        "endDate": endDate,
        "coordinators": coordinators,
        "image": image,
        "organisation": organisation
      };

  factory Activity.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    List<DocumentReference> coordinatoresDocRef =
        new List<DocumentReference>.from(data['coordinators']);
    DocumentReference organisationRef = data['organisation'];
    Timestamp startDate = data['startDate'];
    Timestamp endDate = data['endDate'];

    return Activity(
        id: doc.documentID,
        name: data['name'] ?? '',
        generalDescription: data['generalDescription'] ?? '',
        location: data['location'],
        isActive: data['isActive'] ?? false,
        startDate: startDate.toDate(),
        endDate: endDate.toDate(),
        coordinators:
            coordinatoresDocRef.map((elem) => elem.documentID).toList(),
        image: data['image'] ?? '',
        organisation: organisationRef.documentID);
  }
}
