import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Record {
  final String id;
  final String artist;
  final String title;
  final int rating;
  final String year;
  final String imageUrl;
  bool isFavorite;

  Record({
    @required this.id,
    @required this.title,
    @required this.artist,
    @required this.rating,
    @required this.year,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  factory Record.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data;
    DocumentReference artistRef = data['artist'];

    return Record(
      id: doc.documentID,
      title: data['title'] ?? '',
      artist: artistRef.documentID,
      rating: data['rating'],
      year: data['year'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "artist": artist,
        "ration": rating,
        "year": year,
        "imageUrl": imageUrl
      };
}
