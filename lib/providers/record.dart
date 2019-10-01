import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Record with ChangeNotifier {
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

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    /* final url =
        'https://flutter-update.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    } */
  }
}
