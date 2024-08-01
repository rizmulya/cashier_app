import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/*
 * COLORS
 */
const primaryColor = Color(0xfffacc15); // yellow
// const primaryColor = Colors.blue; // blue
const primaryAccentColor = Colors.black;
const secondaryColor =Color(0xffe8ecff);
const secondaryAccentColor = Colors.black;


/*
 * CURRENCY
 */
final currency = NumberFormat.currency(
  locale: 'id_ID',
  symbol: 'Rp ',
  decimalDigits: 0
);
// final currency = NumberFormat.currency(
//   locale: 'en_US',
//   symbol: '\$',
//   decimalDigits: 2,
// );


/*
 * ONBOARDING DATA
 */
final List<Map<String, String>> onboardingData = [
  {
    'title': 'Kelola Produk dengan Mudah',
    'subtitle': 'Lacak detail produk, stok, harga, dan foto dengan mudah.',
    'image': 'assets/onboarding1.png'
  },
  {
    'title': 'Pencarian Cepat dan Pemindaian Barcode',
    'subtitle': 'Cari dengan cepat dan gunakan pemindaian barcode untuk input dan pembelian yang mudah.',
    'image': 'assets/onboarding2.png'
  },
  {
    'title': 'Hitung Otomatis dan Perbarui Stok',
    'subtitle': 'Hitung total secara otomatis dan perbarui stok dengan setiap pembelian.',
    'image': 'assets/onboarding3.png'
  },
  // {
  //   'title': 'Effortlessly Manage Your Products',
  //   'subtitle':
  //       'Track product details, stock, prices, and photos effortlessly.',
  //   'image': 'assets/onboarding1.png'
  // },
  // {
  //   'title': 'Fast Search and Barcode Scanning',
  //   'subtitle':
  //       'Quickly search and use barcode scanning for easy input and purchases.',
  //   'image': 'assets/onboarding2.png'
  // },
  // {
  //   'title': 'Auto Calculate and Update Stock',
  //   'subtitle':
  //       'Automatically calculate totals and update stock with each purchase.',
  //   'image': 'assets/onboarding3.png'
  // }
];
