import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/models/customers.dart';
import 'package:water_project/screens/vendor/customerList.dart';
import 'package:water_project/services/database.dart';

class Customers extends StatefulWidget {
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Customer>>.value(
      initialData: [],
      value: DatabaseServices().customers,
      child: Scaffold(
        body: CustomerList(),
      ),
    );
  }
}
