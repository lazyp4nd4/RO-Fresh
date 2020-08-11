import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/screens/customer/myOrderTile.dart';
import 'package:water_project/screens/loading.dart';

class OrderCustomer extends StatefulWidget {
  @override
  _OrderCustomerState createState() => _OrderCustomerState();
}

class _OrderCustomerState extends State<OrderCustomer> {
  String userUid;

  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userUid = user.uid;
    });
    return user.uid;
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.BUTTON_BG,
        elevation: 0,
        title: Text(
          'My Orders',
          style: TextStyle(color: Constants.BUTTON_TXT),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('orders')
            .where('customerId', isEqualTo: userUid)
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text('no data');
          } else {
            final list = snapshot.data.documents;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading(
                color: Constants.BUTTON_TXT,
              );
            } else {
              return Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height - 200,
                        width: double.infinity,
                        padding: EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
                        decoration: BoxDecoration(
                            color: Constants.BUTTON_TXT,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4000.0),
                            )),
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return MyOrderTile(
                        amount: list[index]['amount'],
                        brand: list[index]['brand'],
                        delivered: list[index]['delivered'],
                        paidAmount: list[index]['paidAmount'],
                        volume: list[index]['bottleType'],
                        orderQuantity: list[index]['orderQuantity'],
                      );
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
