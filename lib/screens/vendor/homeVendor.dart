import 'package:flutter/material.dart';
import 'package:water_project/screens/products.dart';
import 'package:water_project/screens/vendor/customers.dart';
import 'package:water_project/screens/vendor/orders.dart';

class HomeVendor extends StatefulWidget {
  @override
  _HomeVendorState createState() => _HomeVendorState();
}

class _HomeVendorState extends State<HomeVendor> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Products(),
    Orders(),
    Customers(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 4,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            title: Text('Store'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Orders'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.group), title: Text('Customers'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
