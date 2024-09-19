import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductPage extends StatelessWidget {
  final String productSlug;
  final String id;
  final String token;

  ProductPage({required this.productSlug, required this.id, required this.token});

  Future<Map<String, dynamic>?> fetchProductDetails() async {
    final url = 'https://swan.alisonsnewdemo.online/api/product-details/en/$productSlug?id=$id&token=$token';
    print('Fetching product from: $url');

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        print('Failed to load product. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       
        backgroundColor: const Color.fromARGB(255, 178, 169, 169),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchProductDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text('Failed to load product.'));
          } else {
            final product = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(product['image'] ?? 'https://via.placeholder.com/150'),
                  SizedBox(height: 16),
                  Text(
                    product['name'] ?? 'No Name',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${product['price'] ?? '0.00'}',
                    style: TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  SizedBox(height: 16),
                  Text(
                    product['description'] ?? 'No description available.',
                    style: TextStyle(fontSize: 16),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      
                    },
                    child: Text('Add to Cart'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
