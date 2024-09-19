import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:machine_tes/ui/product.dart';

class ProductsListPage extends StatefulWidget {
  final String id;
  final String token;

  ProductsListPage({required this.id, required this.token});

  @override
  _ProductsListPageState createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url =
        'https://swan.alisonsnewdemo.online/api/products/en?id=${widget.id}&token=${widget.token}&page=1';
    print('Fetching products from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        setState(() {
          products = jsonResponse['data'] ?? [];
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load products. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        backgroundColor: const Color.fromARGB(255, 178, 169, 169),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(product['name'] ?? 'No Name'),
                      subtitle: Text('\$${product['price'] ?? '0.00'}'),
                      leading: Image.network(product['image'] ?? 'https://via.placeholder.com/150'),
                      onTap: () {
                       
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              productSlug: product['slug'],
                              id: widget.id,
                              token: widget.token,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
