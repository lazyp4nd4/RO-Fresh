import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/products.dart';
import 'package:water_project/screens/customer/productTile.dart';

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.BUTTON_TXT,
        elevation: 0,
        title: Text(
          'Store',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 400,
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
            decoration: BoxDecoration(
                color: Constants.BUTTON_TXT,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(400.0),
                )),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 8),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductTile(
                  product: products[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// child: Stack(
//   children: [
//     Container(
//       height: 400,
//       width: double.infinity,
//       padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
//       decoration: BoxDecoration(
//           color: Constants.BUTTON_TXT,
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(400.0),
//           )),
//     ),
//     Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(20),
//           child: ListView.builder(
//             scrollDirection: Axis.vertical,
//             shrinkWrap: true,
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               return ProductTile(
//                 product: products[index],
//               );
//             },
//           ),
//         ),
//       ],
//     )
//   ],
// ),
