import 'dart:io';
import 'package:cashier_app/const.dart';
import 'package:flutter/material.dart';
import 'package:cashier_app/Json/product.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:intl/intl.dart';

class ProductPurchase extends StatefulWidget {
  final Product product;
  const ProductPurchase({super.key, required this.product});

  @override
  _ProductPurchaseState createState() => _ProductPurchaseState();
}

class _ProductPurchaseState extends State<ProductPurchase> {
  final Map<Product, int> _cart = {};
  final TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cart[widget.product] = 1;
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

  Future<void> _checkoutProduct() async {
    final notifier = Provider.of<ProviderDB>(context, listen: false);
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
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _cart.entries
        .map((entry) => entry.key.price * entry.value)
        .fold(0, (sum, item) => sum + item);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Products'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _cart.length,
              itemBuilder: (context, index) {
                final product = _cart.keys.elementAt(index);
                final quantity = _cart[product] ?? 1;
                final totalProductPrice = product.price * quantity;
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
                  subtitle: Text('Total: ${currency.format(totalProductPrice)}'),
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
              'Grand Total: ${currency.format(totalPrice)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: _checkoutProduct,
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: secondaryAccentColor,
                minimumSize: const Size(100, 50),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: _scanBarcode,
              icon: const Icon(Icons.qr_code_scanner, size: 28),
              label: const Text(
                "Scan Again",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                backgroundColor: primaryColor,
                foregroundColor: primaryAccentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
