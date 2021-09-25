import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // @override
  // void didChangeDependencies() {
  //   Provider.of<Orders>(context).fetchAndSetOrders();
  //   super.didChangeDependencies();
  // }

  var _isloading = false;

  @override
  void initState() {
    // Future.delayed(Duration.zero).then((_) async {
    // setState(() {
    _isloading = true;
    // });
    Provider.of<Orders>(context, listen: false).fetchAndSetOrders().then((_) {
      setState(() {
        _isloading = false;
      });
    });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(
                orderData.orders[i],
              ),
            ),
    );
  }
}
