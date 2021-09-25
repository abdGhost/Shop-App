import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url =
        'https://shopapp-71821-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    final response = await http.get(Uri.parse(url));
    print(json.decode(response.body));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;

    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(orderData['dateTime']),
        products: (orderData['products'] as List<dynamic>)
            .map(
              (item) => CartItem(
                id: item['id'],
                price: item['price'],
                quantity: item['quantity'],
                title: item['title'],
              ),
            )
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    const url =
        'https://shopapp-71821-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      Uri.parse(url),
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProduct
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: timeStamp,
        products: cartProduct,
      ),
    );
    notifyListeners();
  }
}
