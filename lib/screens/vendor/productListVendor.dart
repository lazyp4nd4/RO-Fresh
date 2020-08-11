import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/products.dart';
import 'package:water_project/screens/vendor/productTileVendor.dart';
import 'package:water_project/services/database.dart';

class ProductListVendor extends StatefulWidget {
  @override
  _ProductListVendorState createState() => _ProductListVendorState();
}

class _ProductListVendorState extends State<ProductListVendor> {
  int capacity, price;
  String brand;

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    child: Wrap(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Add Product',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 40),
                              Row(
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Brand: ',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blueGrey[400]),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      enabled: true,
                                      decoration: InputDecoration(
                                        fillColor: Constants.BUTTON_BG,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Constants.BUTTON_TXT,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Constants.BUTTON_TXT)),
                                        labelText: 'Brand',
                                        focusColor: Constants.BUTTON_TXT,
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
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Volume: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey[400]),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      decoration: InputDecoration(
                                        fillColor: Constants.BUTTON_BG,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Constants.BUTTON_TXT,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Constants.BUTTON_TXT)),
                                        labelText: 'Volume',
                                        focusColor: Constants.BUTTON_TXT,
                                      ),
                                      onChanged: (text) {
                                        setState(() {
                                          capacity = int.tryParse(text);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Price: ',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.blueGrey[400]),
                                      )),
                                  Expanded(
                                    flex: 2,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      enabled: true,
                                      decoration: InputDecoration(
                                        fillColor: Constants.BUTTON_BG,
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Constants.BUTTON_TXT,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            borderSide: BorderSide(
                                                color: Constants.BUTTON_TXT)),
                                        labelText: 'Price in Rs.',
                                        focusColor: Constants.BUTTON_TXT,
                                      ),
                                      onChanged: (text) {
                                        setState(() {
                                          price = int.tryParse(text);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FlatButton(
                                onPressed: () async {
                                  await DatabaseServices()
                                      .addProduct(capacity, price, brand);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Constants.BUTTON_TXT,
                                      borderRadius: BorderRadius.circular(10)),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    'Save',
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
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Constants.BUTTON_BG,
        ),
        backgroundColor: Constants.BUTTON_TXT,
      ),
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
                const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductTileVendor(
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
