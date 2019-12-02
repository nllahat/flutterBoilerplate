import 'package:flutter_boilerplate/models/organization_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizationService {
  // collection reference
  final CollectionReference organizationsCollection =
      Firestore.instance.collection('organizations');

  // Organization list from snapshot
  List<Organization> _organizationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents
        .map((doc) => Organization.fromFirestore(doc))
        .toList();
  }

  // get organizations stream
  Stream<List<Organization>> get organizationsStream {
    return organizationsCollection
        .snapshots()
        .map(_organizationListFromSnapshot);
  }

  Future<List<Organization>> get organizationList {
    return organizationsCollection
        .getDocuments()
        .then((QuerySnapshot querySnapshot) {
      return _organizationListFromSnapshot(querySnapshot);
    });
  }

  Future<Organization> setOrAddUser(Organization organization) async {
    Map<String, dynamic> jsonMap = organization.toJson();

    try {
      DocumentReference docRef = organizationsCollection.document(organization.id);
      await docRef.setData(jsonMap, merge: true);
      print("Document updated with ID: ${docRef.documentID}");

      return Organization.fromFirestore(await docRef.get());
    } catch (e) {
      print("Error adding document: $e");
      throw e;
    }
  }

  Future<Organization> addOrganization(Organization organization) async {
    Map<String, dynamic> jsonMap = organization.toJson();

    try {
      DocumentReference docRef = await organizationsCollection.add(jsonMap);
      print("Document written with ID: ${docRef.documentID}");

      return Organization.fromFirestore(await docRef.get());
    } catch (e) {
      print("Error adding document: $e");
      throw e;
    }
  }
}
