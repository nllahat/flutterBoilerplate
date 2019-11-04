import '../models/record.dart';
import 'package:flutter/foundation.dart';

class RecordProvider with ChangeNotifier {
  final Record record;

  RecordProvider({
    @required this.record
  });

  void _setFavValue(bool newValue) {
    this.record.isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = this.record.isFavorite;
    this.record.isFavorite = !this.record.isFavorite;
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
