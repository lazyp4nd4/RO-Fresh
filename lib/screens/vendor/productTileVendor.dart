import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/products.dart';
import 'package:water_project/services/database.dart';

class ProductTileVendor extends StatefulWidget {
  final Product product;
  ProductTileVendor({this.product});

  @override
  _ProductTileVendorState createState() => _ProductTileVendorState();
}

class _ProductTileVendorState extends State<ProductTileVendor> {
  int capacity, price;
  String brand;
  int amount = 0;
  int orderQuantity = 1;

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
                Expanded(
                  flex: 1,
                  child: Text('Rs. ${widget.product.price}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(builder: (BuildContext
                                    context,
                                StateSetter
                                    setModalState /*You can rename this!*/) {
                              return Padding(
                                  padding: MediaQuery.of(context).viewInsets,
                                  child: Container(
                                      padding: EdgeInsets.only(
                                          left: 25,
                                          right: 25,
                                          bottom: 50,
                                          top: 40),
                                      child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Brand: ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors
                                                            .blueGrey[400]),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    enabled: true,
                                                    decoration: InputDecoration(
                                                      fillColor:
                                                          Constants.BUTTON_BG,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Constants
                                                              .BUTTON_TXT,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              color: Constants
                                                                  .BUTTON_TXT)),
                                                      hintText: '$brand',
                                                      focusColor:
                                                          Constants.BUTTON_TXT,
                                                    ),
                                                    onChanged: (text) {
                                                      setState(() {
                                                        brand = text;
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Volume: ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors
                                                            .blueGrey[400]),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    enabled: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    decoration: InputDecoration(
                                                      fillColor:
                                                          Constants.BUTTON_BG,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Constants
                                                              .BUTTON_TXT,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              color: Constants
                                                                  .BUTTON_TXT)),
                                                      hintText: '$capacity L',
                                                      focusColor:
                                                          Constants.BUTTON_TXT,
                                                    ),
                                                    onChanged: (text) {
                                                      setState(() {
                                                        capacity =
                                                            int.tryParse(text);
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    'Price: ',
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        color: Colors
                                                            .blueGrey[400]),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: TextField(
                                                    keyboardType:
                                                        TextInputType.number,
                                                    enabled: true,
                                                    decoration: InputDecoration(
                                                      fillColor:
                                                          Constants.BUTTON_BG,
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                          color: Constants
                                                              .BUTTON_TXT,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide: BorderSide(
                                                              color: Constants
                                                                  .BUTTON_TXT)),
                                                      hintText: 'Rs $price',
                                                      focusColor:
                                                          Constants.BUTTON_TXT,
                                                    ),
                                                    onChanged: (text) {
                                                      setState(() {
                                                        price =
                                                            int.tryParse(text);
                                                      });
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 40),
                                            Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  FlatButton(
                                                    onPressed: () async {
                                                      await DatabaseServices()
                                                          .updateProduct(
                                                              capacity,
                                                              price,
                                                              brand,
                                                              widget.product
                                                                  .productId);
                                                      Navigator.of(context)
                                                          .pop();
                                                      showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                              ),
                                                              child: Container(
                                                                child: Wrap(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              20),
                                                                      child: Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            RawMaterialButton(
                                                                              onPressed: () {},
                                                                              fillColor: Constants.BUTTON_TXT,
                                                                              shape: CircleBorder(),
                                                                              elevation: 0,
                                                                              padding: EdgeInsets.all(20),
                                                                              child: Icon(
                                                                                Icons.check,
                                                                                size: 30,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              'Product Updated!',
                                                                              style: TextStyle(
                                                                                fontSize: 22,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Text(
                                                                              'The product has been updated with the details provided.',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 50,
                                                                            ),
                                                                            FlatButton(
                                                                              onPressed: () async {
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(color: Constants.BUTTON_TXT, borderRadius: BorderRadius.circular(10)),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                child: Text(
                                                                                  'Continue',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                          color: Constants
                                                              .BUTTON_BG,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                16, 8, 16, 8),
                                                        child: Text(
                                                            'Update Product',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 23,
                                                              color: Constants
                                                                  .BUTTON_TXT,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  FlatButton(
                                                      child: Container(
                                                        width: double.infinity,
                                                        decoration: BoxDecoration(
                                                            color: Constants
                                                                .BUTTON_BG,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .fromLTRB(
                                                                  16, 8, 16, 8),
                                                          child: Text(
                                                              'Delete Product',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                fontSize: 23,
                                                                color: Constants
                                                                    .BUTTON_TXT,
                                                              )),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        DatabaseServices()
                                                            .removeProduct(
                                                                widget.product
                                                                    .productId);
                                                        Navigator.of(context)
                                                            .pop();
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return Dialog(
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                                child:
                                                                    Container(
                                                                        child: Wrap(
                                                                            children: [
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(20),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            RawMaterialButton(
                                                                              onPressed: () {},
                                                                              fillColor: Constants.BUTTON_TXT,
                                                                              shape: CircleBorder(),
                                                                              elevation: 0,
                                                                              padding: EdgeInsets.all(20),
                                                                              child: Icon(
                                                                                Icons.check,
                                                                                size: 30,
                                                                                color: Colors.white,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 20,
                                                                            ),
                                                                            Text(
                                                                              'Product Removed!',
                                                                              style: TextStyle(
                                                                                fontSize: 22,
                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Text(
                                                                              'The product has been removed successfully!',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(
                                                                                fontSize: 16,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 50,
                                                                            ),
                                                                            FlatButton(
                                                                              onPressed: () async {
                                                                                //await DatabaseServices().removeProduct(widget.product.productId);
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Container(
                                                                                decoration: BoxDecoration(color: Constants.BUTTON_TXT, borderRadius: BorderRadius.circular(10)),
                                                                                width: MediaQuery.of(context).size.width,
                                                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                                child: Text(
                                                                                  'Continue',
                                                                                  style: TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 20,
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ])));
                                                          },
                                                        );
                                                      })
                                                ])
                                          ])));
                            });
                          });
                    },
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Constants.BUTTON_BG,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text('Edit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.BUTTON_TXT,
                            )),
                      ),
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
