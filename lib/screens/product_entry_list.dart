import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:strivio/models/product_entry.dart';
import 'package:strivio/widgets/product_entry_card.dart';
import 'package:strivio/widgets/left_drawer.dart';
import 'package:strivio/screens/product_detail.dart';

class ProductEntryListPage extends StatefulWidget {
  const ProductEntryListPage({super.key});

  @override
  State<ProductEntryListPage> createState() => _ProductEntryListPageState();
}

class _ProductEntryListPageState extends State<ProductEntryListPage> {
  
  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    // Ganti URL ke URL Django lu + trailing slash
    final response = await request.get("http://localhost:8000/json/");

    List<ProductEntry> listProducts = [];

    for (var d in response) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }

    return listProducts;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
      ),
      drawer: const LeftDrawer(),

      body: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot snapshot) {
          
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Column(
              children: [
                SizedBox(height: 20),
                Text(
                  "There are no products in Strivio yet.",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff59A5D8),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (_, index) {
              final product = snapshot.data![index];

              return ProductEntryCard(
                product: product,
                onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                        product: snapshot.data![index],
                    ),
                    ),
                );
                },
              );
            },
          );
        },
      ),
    );
  }
}
