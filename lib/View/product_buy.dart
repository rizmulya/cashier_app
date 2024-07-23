import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cashier_app/Json/product.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:intl/intl.dart';

class ProductBuy extends StatefulWidget {
  final Product product;
  const ProductBuy({super.key, required this.product});

  @override
  _ProductBuyState createState() => _ProductBuyState();
}

class _ProductBuyState extends State<ProductBuy> {
  final Map<Product, int> _cart = {};
  final TextEditingController _quantityController = TextEditingController();
  final currency =
      NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  void initState() {
    super.initState();
    _cart[widget.product] = 1; // Default quantity for the scanned product
  }

  void _incrementQuantity(Product product) {
    setState(() {
      _cart[product] = (_cart[product] ?? 1) + 1;
    });
  }

  void _decrementQuantity(Product product) {
    setState(() {
      if ((_cart[product] ?? 1) > 1) {
        _cart[product] = (_cart[product] ?? 1) - 1;
      }
    });
  }

  void _addProductToCart(Product product) {
    setState(() {
      _cart[product] = (_cart[product] ?? 1) + 1;
    });
  }

  void _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        final notifier = Provider.of<ProviderDB>(context, listen: false);
        final Product? foundProduct = notifier.firstWhereOrNull(
            (product) => product.productCode == result.rawContent);

        if (foundProduct != null) {
          setState(() {
            _addProductToCart(foundProduct);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Not found: ${result.rawContent}')),
          );
        }
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _cart.entries
        .map((entry) => entry.key.price * entry.value)
        .fold(0, (sum, item) => sum + item);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Products'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                final notifier =
                    Provider.of<ProviderDB>(context, listen: false);
                _cart.forEach((product, quantity) {
                  notifier.updateProduct(
                    Product(
                      id: product.id,
                      name: product.name,
                      productCode: product.productCode,
                      price: product.price,
                      stock: product.stock - quantity,
                      image: product.image,
                      isCompleted: product.isCompleted,
                    ),
                    imageFile: null,
                    oldImagePath: product.image,
                  );
                });
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _scanBarcode,
            child: const Text("Scan Product Code"),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final product = _cart.keys.elementAt(index);
                final quantity = _cart[product] ?? 1;
                return ListTile(
                  leading: product.image != null
                      ? Image.file(
                          File(product.image!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(product.name),
                  subtitle: Row(
                    children: [
                      Text(currency.format(product.price)),
                      const SizedBox(width: 8),
                      Text('Stock: ${product.stock}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => _decrementQuantity(product),
                      ),
                      Text('$quantity'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _incrementQuantity(product),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total: ${currency.format(totalPrice)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
