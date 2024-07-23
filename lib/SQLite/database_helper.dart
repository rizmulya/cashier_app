import 'dart:io';
import 'package:cashier_app/Json/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "cashierApp.db";
  static String productTableName = "product";

  // Table for product
  String productTable = '''
  CREATE TABLE IF NOT EXISTS $productTableName (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    productCode TEXT,
    price INTEGER,
    stock INTEGER,
    image TEXT,
    isCompleted INTEGER
  )''';

  // Database Connection
  Future<Database> initDB() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$databaseName";
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(productTable);
    });
  }

  // CRUD Methods
  // Get product
  Future<List<Product>> getProduct() async {
    final db = await initDB();
    final List<Map<String, Object?>> res = await db.query(productTableName); //list=array, map=json
    return res.map((e) => Product.fromMap(e)).toList();
  }

  // Add product
  Future<void> addProduct(Product product, {File? imageFile}) async {
    final db = await initDB();
    if (imageFile != null) {
      String imagePath = await saveImage(imageFile);
      product = product.copyWith(image: imagePath);
    }
    await db.insert(productTableName, product.toMap());
  }

  // Update product
  Future<void> updateProduct(Product product, {File? imageFile, String? oldImagePath}) async {
    final db = await initDB();

    if (imageFile != null) {
      String newImagePath = await saveImage(imageFile);
      product = product.copyWith(image: newImagePath);
    }

    await db.update(productTableName, product.toMap(), where: "id = ?", whereArgs: [product.id]);

    if (imageFile != null && oldImagePath != null) {
      await deleteImage(oldImagePath);
    }
  }

  // Delete product
  Future<void> deleteProduct(Product product) async {
    final db = await initDB();
    if (product.image != null) {
      await deleteImage(product.image!);
    }
    db.delete(productTableName, where: "id = ?", whereArgs: [product.id]);
  }

  // Delete image file from storage
  Future<void> deleteImage(String imagePath) async {
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      await imageFile.delete();
    }
  }

  // Save image to storage
  Future<String> saveImage(File imageFile) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = imageFile.path.split('/').last;
    final savedImage = await imageFile.copy('${appDir.path}/$fileName');
    return savedImage.path;
  }
}
