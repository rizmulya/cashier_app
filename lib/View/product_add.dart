import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cashier_app/Json/product.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ProductAdd extends StatefulWidget {
  const ProductAdd({super.key});

  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final picker = ImagePicker();
  File? _imageFile;

  Future<void> _addProduct() async {
    if (_formKey.currentState!.validate()) {
      final notifier = Provider.of<ProviderDB>(context, listen: false);
      await notifier.insertProduct(
        Product(
          name: name.text,
          productCode: productCode.text,
          price: int.parse(price.text),
          stock: int.parse(stock.text),
          image: _imageFile?.path,
          isCompleted: false,
        ),
        imageFile: _imageFile,
      );
      Navigator.pop(context);
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Tambahkan error handling
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan();
      setState(() {
        productCode.text = result.rawContent;
      });
    } catch (e) {
      // Tambahkan error handling
      print('Error scanning barcode: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to scan barcode: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Product"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: _addProduct,
              icon: const Icon(Icons.check),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _scanBarcode,
                  child: const Text("Scan Product Code"),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: productCode,
                  decoration: const InputDecoration(
                    hintText: "Product Code",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product code';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: name,
                  decoration: const InputDecoration(
                    hintText: "Product Name",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: price,
                  decoration: const InputDecoration(
                    hintText: "Product Price",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: stock,
                  decoration: const InputDecoration(
                    hintText: "Product Stock",
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the product stock';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        width: 300,
                        fit: BoxFit.cover,
                      )
                    : const Text('No image selected'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _showImageSourceActionSheet(context),
                  child: const Text("Add Image"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
