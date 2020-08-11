import 'package:flutter/material.dart';
import 'package:water_project/screens/customer/myOrders.dart';
import 'package:water_project/screens/customer/profile.dart';
import 'package:water_project/screens/products.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Products(),
    OrderCustomer(),
    ProfileCustomer(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
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
              icon: Icon(Icons.person), title: Text('Profile'))
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
