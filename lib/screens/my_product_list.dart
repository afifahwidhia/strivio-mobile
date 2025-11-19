import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:strivio/models/product_entry.dart';
import 'package:strivio/widgets/product_entry_card.dart';
import 'package:strivio/widgets/left_drawer.dart';
import 'package:strivio/screens/product_detail.dart';

class MyProductListPage extends StatefulWidget {
  const MyProductListPage({super.key});

  @override
  State<MyProductListPage> createState() => _MyProductListPageState();
}

class _MyProductListPageState extends State<MyProductListPage> {

  Future<List<ProductEntry>> fetchMyProducts(CookieRequest request) async {
    final response = await request.get("http://localhost:8000/json/");

    String currentUsername = request.jsonData["username"];

    List<ProductEntry> allProducts = [];
    for (var d in response) {
      if (d != null) {
        allProducts.add(ProductEntry.fromJson(d));
      }
    }

    List<ProductEntry> myProducts = allProducts
        .where((product) => product.username == currentUsername)
        .toList();

    return myProducts;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Products"),
      ),
      drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchMyProducts(request),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "You haven't added any products yet.",
                style: TextStyle(fontSize: 18),
              ),
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
                        builder: (context) => ProductDetailPage(product: product),
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
