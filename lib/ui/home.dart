import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String id; 
  final String token; 

  HomeScreen({required this.id, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  String? errorMessage;
  List<dynamic> products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = 'https://swan.alisonsnewdemo.online/api/home?id=${widget.id}&token=${widget.token}';
    print('Fetching data from: $url'); 

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print(response.body);
        final jsonResponse = json.decode(response.body);
        
        if (jsonResponse['data'] != null) {
          setState(() {
            products = jsonResponse['data'];
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = 'No products found';
            isLoading = false;
          });
        }
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
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
             
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
             
            },
          ),
        ],
      ),
      
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : SingleChildScrollView(scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      ListView.builder(
                        itemCount: products.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            title: Text(product['name'] ?? 'No Name'), 
                            subtitle: Text('\$${product['price'] ?? '0.00'}'), 
                            leading: Image.network(product['image'] ?? 'https://via.placeholder.com/150'), 
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}


