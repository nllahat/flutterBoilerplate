import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/record.dart';
import './record_provider.dart';

class RecordsProvider with ChangeNotifier {
  List<RecordProvider> _items = [];
  final CollectionReference _db = Firestore.instance.collection('records');

  RecordsProvider(this._items);

  List<RecordProvider> get items {
    return [..._items];
  }

  List<RecordProvider> get favoriteItems {
    return _items.where((prodItem) => prodItem.record.isFavorite).toList();
  }

  RecordProvider findById(String id) {
    return _items
        .firstWhere((recordProvider) => recordProvider.record.id == id);
  }

  Future<void> fetchAndSetRecords([bool filterByUser = false]) async {
    final List<RecordProvider> loadedRecords = [];

    try {
      QuerySnapshot docs = await _db.getDocuments();
      docs.documents.forEach((doc) {
        loadedRecords.add(RecordProvider(record: Record.fromFirestore(doc)));
      });
      _items = loadedRecords;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addRecord(Record record) {
    Map<String, dynamic> jsonMap = record.toJson();
    jsonMap["artist"] = _db.document("artists/${jsonMap["artist"]}");

    return _db.add(jsonMap).then((DocumentReference value) {
      value.get().then((onValue) {
        final newRecord = Record.fromFirestore(onValue);
        _items.add(RecordProvider(record: newRecord));
        notifyListeners();
      });
    }).catchError((onError) {
      throw onError;
    });
  }

  /*Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-update.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }*/
}
