import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cashier_app/Json/product.dart';
import 'package:cashier_app/Provider/provider_db.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:barcode_scan2/barcode_scan2.dart';

class ProductUpdate extends StatefulWidget {
  final Product? product;
  const ProductUpdate({super.key, this.product});

  @override
  _ProductUpdateState createState() => _ProductUpdateState();
}

class _ProductUpdateState extends State<ProductUpdate> {
  final TextEditingController name = TextEditingController();
  final TextEditingController productCode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController stock = TextEditingController();
  final picker = ImagePicker();
  File? _newImage;
  String? _oldImagePath;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      name.text = widget.product!.name;
      productCode.text = widget.product!.productCode;
      price.text = widget.product!.price.toString();
      stock.text = widget.product!.stock.toString();
      _oldImagePath = widget.product!.image;
    }
  }

  Future<void> _updateProduct() async {
    final notifier = Provider.of<ProviderDB>(context, listen: false);
    await notifier.updateProduct(
      Product(
        id: widget.product!.id,
        name: name.text,
        productCode: productCode.text,
        price: int.parse(price.text),
        stock: int.parse(stock.text),
        image: _newImage?.path ?? _oldImagePath,
        isCompleted: widget.product?.isCompleted ?? false,
      ),
      imageFile: _newImage,
      oldImagePath: _oldImagePath,
    );
    Navigator.pop(context);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _newImage = File(pickedFile.path);
      });
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
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _scanBarcode() async {
    var result = await BarcodeScanner.scan();
    setState(() {
      productCode.text = result.rawContent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Product"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: _updateProduct,
              icon: const Icon(Icons.check),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
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
              ),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  hintText: "Product Name",
                ),
              ),
              TextFormField(
                controller: price,
                decoration: const InputDecoration(
                  hintText: "Product Price",
                ),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: stock,
                decoration: const InputDecoration(
                  hintText: "Product Stock",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              if (_newImage != null)
                Image.file(_newImage!)
              else if (_oldImagePath != null)
                Image.file(File(_oldImagePath!)),
              ElevatedButton(
                onPressed: () => _showImageSourceActionSheet(context),
                child: const Text("Update Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
