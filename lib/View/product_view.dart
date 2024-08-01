import 'dart:io';
import 'package:cashier_app/View/product_purchase.dart';
import 'package:cashier_app/const.dart';
import 'package:flutter/material.dart';
import 'package:cashier_app/Json/product.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:cashier_app/View/product_add.dart';
import 'package:cashier_app/View/product_update.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ProductView extends StatefulWidget {
  const ProductView({super.key});

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final TextEditingController _searchController = TextEditingController();

  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result.rawContent.isNotEmpty) {
        final notifier = Provider.of<ProviderDB>(context, listen: false);
        final Product? foundProduct = notifier.firstWhereOrNull(
            (product) => product.productCode == result.rawContent);

        if (foundProduct != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductPurchase(
                product: foundProduct,
              ),
            ),
          );
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

  void _confirmDelete(Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete ${product.name}?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: secondaryColor,
                foregroundColor: secondaryAccentColor,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                final notifier =
                    Provider.of<ProviderDB>(context, listen: false);
                notifier.deleteProduct(product);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: primaryAccentColor,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderDB>(
      builder: (context, notifier, child) {
        return Scaffold(
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProductAdd()),
                  );
                },
                backgroundColor: secondaryColor,
                icon: const Icon(
                  Icons.edit_square,
                  color: Colors.black,
                ),
                label: const Text(
                  'Add',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _scanBarcode,
                icon: const Icon(Icons.qr_code_scanner, size: 28),
                label: const Text(
                  "Purchase",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: primaryColor,
                  foregroundColor: primaryAccentColor,
                  elevation: 5,
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: const Text('Products'),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                    filled: true,
                  ),
                  onChanged: (value) {
                    notifier.searchProduct(value);
                  },
                ),
              ),
            ),
          ),
          body: notifier.product.isEmpty
              ? const Center(child: Text("No Product"))
              : ListView.builder(
                  itemCount: notifier.product.length,
                  itemBuilder: (context, index) {
                    Product product = notifier.product[index];
                    return ListTile(
                      leading: product.image != null
                          ? Image.file(
                              File(product.image!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : const Icon(Icons.image, size: 50),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(currency.format(product.price)),
                          Text('Stock: ${product.stock.toString()}'),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () => _confirmDelete(product),
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductUpdate(product: product),
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
