import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/orders.dart';
import 'package:water_project/auth/register.dart';
import 'package:water_project/screens/vendor/orderTile.dart';
import 'package:water_project/services/authServices.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<List<Order>>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.BUTTON_BG,
        elevation: 0,
        title: Text(
          'Orders',
          style: TextStyle(color: Constants.BUTTON_TXT),
        ),
      ),
      body: Stack(
        children: [
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height - 200,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0),
              decoration: BoxDecoration(
                  color: Constants.BUTTON_TXT,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40000.0),
                  )),
            ),
          ),
          ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return OrderTile(
                order: orders[index],
              );
            },
          ),
        ],
      ),
    );
  }
}
