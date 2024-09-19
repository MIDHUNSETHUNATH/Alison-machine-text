import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartController extends GetxController {
  var cartItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  Future<void> addToCart(String id, String token, String productSlug) async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('https://swan.alisonsnewdemo.online/api/cart/add/en?id=$id&token=$token&slug=$productSlug&quantity=1&store=swan'),
    );

    if (response.statusCode == 200) {
    
      cartItems.add(json.decode(response.body)); 
    } else {
      throw Exception('Failed to add item to cart');
    }
    isLoading.value = false;
  }

  Future<void> fetchCart(String id, String token) async {
    isLoading.value = true;
    final response = await http.get(
      Uri.parse('https://swan.alisonsnewdemo.online/api/cart/en?id=$id&token=$token&for=summary'),
    );

    if (response.statusCode == 200) {
      cartItems.value = List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch cart data');
    }
    isLoading.value = false;
  }
}

