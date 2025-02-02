// Generated by QuickType | Json Generator (https://app.quicktype.io/)
// settings: (json, null safety, make all properties required & final, generate CopyWith method, Use method names fromMap() & toMap())
//
// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);
import 'dart:convert';

// the data model for product

// json/map to object
Product productFromMap(String str) => Product.fromMap(json.decode(str));
// object to json/map
String productToMap(Product data) => json.encode(data.toMap());

class Product {
    final int? id;
    final String name;
    final String productCode;
    final int price;
    final int stock;
    final String? image;
    final bool isCompleted;

    Product({
        this.id,
        required this.name,
        required this.productCode,
        required this.price,
        required this.stock,
        this.image,
        required this.isCompleted,
    });

    Product copyWith({
        int? id,
        String? name,
        String? productCode,
        int? price,
        int? stock,
        String? image,
        bool? isCompleted,
    }) => 
        Product(
            id: id ?? this.id,
            name: name ?? this.name,
            productCode: productCode ?? this.productCode,
            price: price ?? this.price,
            stock: stock ?? this.stock,
            image: image ?? this.image,
            isCompleted: isCompleted ?? this.isCompleted,
        );

    factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        productCode: json["productCode"],
        price: json["price"],
        stock: json["stock"],
        image: json["image"],
        isCompleted: json["isCompleted"] == 1,
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "productCode": productCode,
        "price": price,
        "stock": stock,
        "image": image,
        "isCompleted": isCompleted,
    };
}