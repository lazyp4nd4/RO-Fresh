import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/models/orders.dart';
import 'package:water_project/screens/vendor/orderList.dart';
import 'package:water_project/services/database.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Order>>.value(
      initialData: [],
      value: DatabaseServices().orders,
      child: Scaffold(
        body: OrderList(),
      ),
    );
  }
}
