import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './record.dart';

class Records with ChangeNotifier {
  List<Record> _items = [];
  final CollectionReference _db = Firestore.instance.collection('records');

  Records(this._items);

  List<Record> get items {
    return [..._items];
  }

  List<Record> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Record findById(String id) {
    return _items.firstWhere((record) => record.id == id);
  }

  Future<void> fetchAndSetRecords([bool filterByUser = false]) async {
    final List<Record> loadedRecords = [];

    try {
      QuerySnapshot docs = await _db.getDocuments();
      docs.documents.forEach((doc) {
        loadedRecords.add(Record.fromFirestore(doc));
      });
      _items = loadedRecords;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  /*Future<void> addProduct(Product product) async {
    final url =
        'https://flutter-update.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
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
