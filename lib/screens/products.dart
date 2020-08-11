import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/products.dart';
import 'package:water_project/screens/loading.dart';
import 'package:water_project/screens/customer/productList.dart';
import 'package:water_project/screens/vendor/productListVendor.dart';
import 'package:water_project/services/database.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  bool vendor;
  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> setVendor() async {
    String uid = await getCurrentUser();
    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .get()
        .then((value) {
      if (value.data['isVendor'] == true) {
        setState(() {
          vendor = true;
        });
      } else {
        setState(() {
          vendor = false;
        });
      }
    });
  }

  @override
  void initState() {
    setVendor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return vendor != null
        ? Scaffold(
            body: StreamProvider<List<Product>>.value(
              initialData: [],
              value: DatabaseServices().products,
              child:
                  Scaffold(body: vendor ? ProductListVendor() : ProductList()),
              //child: ProductList(),
            ),
          )
        : Loading(
            color: Constants.BUTTON_TXT,
          );
  }
}
