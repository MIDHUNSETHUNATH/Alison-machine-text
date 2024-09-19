import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:machine_tes/controller/cart_controller.dart';


class CartPage extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (cartController.cartItems.isEmpty) {
          return Center(child: Text('Your cart is empty.'));
        }

        return ListView.builder(
          itemCount: cartController.cartItems.length,
          itemBuilder: (context, index) {
            final item = cartController.cartItems[index];
            return ListTile(
              title: Text(item['name'] ?? 'Item'),
              subtitle: Text('Quantity: ${item['quantity'] ?? 1}'),
            );
          },
        );
      }),
    );
  }
}
