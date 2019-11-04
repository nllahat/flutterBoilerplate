import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Artist {
  final String id;
  final String name;

  Artist({
    @required this.id,
    @required this.name,
  });

  factory Artist.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;

    return Artist(
      id: doc.documentID,
      name: data['name'] ?? '',
    );
  }
}
