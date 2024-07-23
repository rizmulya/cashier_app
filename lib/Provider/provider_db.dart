import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:cashier_app/SQLite/database_helper.dart';
import '../Json/product.dart';

// manage the state using ChangeNotifier
class ProviderDB extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // store in the _product
  List<Product> _product = [];
  List<Product> _allProducts = [];
  List<Product> get product => _product;

  // Product Fetch
  Future<void> fetchProduct() async {
    await _databaseHelper.initDB();
    _allProducts = await _databaseHelper.getProduct();
    _product = _allProducts;
    notifyListeners();
  }

  // Search products
  void searchProduct(String query) {
    if (query.isEmpty) {
      _product = _allProducts;
    } else {
      _product = _allProducts.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  // Product Insert
  Future<void> insertProduct(Product product, {File? imageFile}) async {
    await _databaseHelper.initDB();
    await _databaseHelper.addProduct(product, imageFile: imageFile);
    await fetchProduct();
  }

  // Product Update
  Future<void> updateProduct(Product product, {File? imageFile, String? oldImagePath}) async {
    await _databaseHelper.initDB();
    await _databaseHelper.updateProduct(product, imageFile: imageFile, oldImagePath: oldImagePath);
    await fetchProduct();
  }

  // Product Delete
  Future<void> deleteProduct(Product product) async {
    await _databaseHelper.initDB();
    _databaseHelper.deleteProduct(product);
    await fetchProduct();
  }

  Product? firstWhereOrNull(bool Function(Product product) test) {
    for (Product product in _allProducts) {
      if (test(product)) return product;
    }
    return null;
  }

  //Init
  /// Init method, to initialize Product list on the start
  init() {
    fetchProduct();
    notifyListeners();
  }
}
