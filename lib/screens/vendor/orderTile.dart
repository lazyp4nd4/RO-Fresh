import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/orders.dart';
import 'package:water_project/services/database.dart';

class OrderTile extends StatefulWidget {
  final Order order;
  OrderTile({this.order});

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  getUserAccount() async {
    await Firestore.instance
        .collection('profiles')
        .document(widget.order.customerId)
        .get()
        .then((value) {
      setState(() {
        account = value.data['account'];
      });
    });
  }

  int account;
  int collectedAmount;
  bool showMarkButton = false;

  @override
  void initState() {
    getUserAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (BuildContext context,
                  StateSetter setModalState /*You can rename this!*/) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 25, right: 25, bottom: 50, top: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Brand: ',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey[400]),
                            )),
                            Expanded(
                              child: Text(
                                '${widget.order.brand}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Volume: ',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey[400]),
                            )),
                            Expanded(
                              child: Text(
                                '${widget.order.bottleType} L',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              'Amount: ',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey[400]),
                            )),
                            Expanded(
                              child: Text(
                                'Rs. ${widget.order.amount}',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w400),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          enabled: true,
                          decoration: InputDecoration(
                            fillColor: Constants.BUTTON_BG,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Constants.BUTTON_TXT,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    BorderSide(color: Constants.BUTTON_TXT)),
                            labelText: 'Amount Collected',
                            focusColor: Constants.BUTTON_TXT,
                          ),
                          onSubmitted: (text) async {
                            if (text != null) {
                              setState(() {
                                collectedAmount = int.tryParse(text);
                                showMarkButton = true;
                              });

                              // await DatabaseServices().addPaidAmount(
                              //     int.tryParse(text), widget.order.orderId);
                            }
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            UrlLauncher.launch(
                                'tel:${widget.order.phoneNumber}');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Constants.BUTTON_BG,
                                borderRadius: BorderRadius.circular(10)),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 10),
                            child: Text(
                              'Call Customer',
                              style: TextStyle(
                                color: Constants.BUTTON_TXT,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        showMarkButton
                            ? FlatButton(
                                onPressed: () async {
                                  account +=
                                      collectedAmount - widget.order.amount;
                                  await DatabaseServices().addPaidAmount(
                                      collectedAmount, widget.order.orderId);
                                  await DatabaseServices().handleUserAccount(
                                      account, widget.order.customerId);
                                  await DatabaseServices()
                                      .markAsDone(widget.order.orderId);
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: Color(0xffE0E4F2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 16, 8),
                                    child: Text('Mark As Done',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Color(0xff1173F1),
                                        )),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                );
              });
            });
      },
      child: Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${widget.order.name}',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Volume: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          '${widget.order.bottleType} L',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          '${widget.order.orderQuantity}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          'Rs ${widget.order.amount}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ]))),
    );
  }
}
