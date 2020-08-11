import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/products.dart';
import 'package:water_project/services/database.dart';

class ProductTile extends StatefulWidget {
  final Product product;
  ProductTile({this.product});

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  int capacity, price;
  String brand;
  int amount = 0;
  int orderQuantity = 1;
  String userUid;

  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      userUid = user.uid;
    });
    return user.uid;
  }

  Future<void> getPricing() async {
    await Firestore.instance
        .collection('products')
        .document(widget.product.productId)
        .get()
        .then((value) {
      setState(() {
        capacity = value.data['capacity'];
        price = value.data['price'];
        brand = value.data['brand'];
        amount = price;
      });
    });
  }

  @override
  void initState() {
    getPricing();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '${widget.product.brand}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              'Single bottle of ${widget.product.capacity} L volume',
              style: TextStyle(fontSize: 16, color: Colors.blueGrey[400]),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Rs. ${widget.product.price}',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    )),
                FlatButton(
                  onPressed: () {
                    showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (BuildContext context,
                              StateSetter
                                  setModalState /*You can rename this!*/) {
                            return Container(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, bottom: 50, top: 40),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Brand: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey[400]),
                                      )),
                                      Expanded(
                                        child: Text(
                                          '$brand',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Volume: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey[400]),
                                      )),
                                      Expanded(
                                        child: Text(
                                          '$capacity L',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        'Price: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey[400]),
                                      )),
                                      Expanded(
                                        child: Text(
                                          'Rs. $price',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('Rs. ',
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text('$amount',
                                          style: TextStyle(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        children: [
                                          RawMaterialButton(
                                            onPressed: () {
                                              setModalState(() {
                                                orderQuantity--;
                                                amount = price * orderQuantity;
                                              });
                                            },
                                            elevation: 0,
                                            hoverElevation: 2,
                                            padding: EdgeInsets.all(10),
                                            shape: CircleBorder(),
                                            fillColor: Constants.BUTTON_BG,
                                            child: Icon(
                                              Icons.arrow_downward,
                                              color: Constants.BUTTON_TXT,
                                              size: 20,
                                            ),
                                          ),
                                          Text(
                                            '$orderQuantity',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.BUTTON_TXT,
                                            ),
                                          ),
                                          RawMaterialButton(
                                            onPressed: () {
                                              setModalState(() {
                                                orderQuantity++;
                                                amount = price * orderQuantity;
                                              });
                                            },
                                            elevation: 0,
                                            hoverElevation: 2,
                                            padding: EdgeInsets.all(10),
                                            shape: CircleBorder(),
                                            fillColor: Constants.BUTTON_BG,
                                            child: Icon(
                                              Icons.arrow_upward,
                                              size: 20,
                                              color: Constants.BUTTON_TXT,
                                            ),
                                          ),
                                        ],
                                      ),
                                      FlatButton(
                                        onPressed: () async {
                                          await DatabaseServices().placeOrder(
                                              orderQuantity,
                                              userUid,
                                              amount,
                                              capacity,
                                              brand);
                                          setState(() {
                                            orderQuantity = 1;
                                            amount = price;
                                          });
                                          Navigator.pop(context);
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Container(
                                                    child: Wrap(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(20),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              RawMaterialButton(
                                                                onPressed:
                                                                    () {},
                                                                fillColor: Constants
                                                                    .BUTTON_TXT,
                                                                shape:
                                                                    CircleBorder(),
                                                                elevation: 0,
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            20),
                                                                child: Icon(
                                                                  Icons.check,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Text(
                                                                'Order Placed!',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 22,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                  height: 10),
                                                              Text(
                                                                'Order has been placed successfully. Please be ready with the amount in cash.',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 50,
                                                              ),
                                                              FlatButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Constants
                                                                          .BUTTON_TXT,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10)),
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          10,
                                                                      vertical:
                                                                          10),
                                                                  child: Text(
                                                                    'Continue Shopping!',
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          20,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Color(0xffE0E4F2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 8, 16, 8),
                                            child: Text('Order',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xff1173F1),
                                                )),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Constants.BUTTON_BG,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Text('Details',
                          style: TextStyle(
                            fontSize: 18,
                            color: Constants.BUTTON_TXT,
                          )),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
