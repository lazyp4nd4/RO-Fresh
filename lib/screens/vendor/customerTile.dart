import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:water_project/services/constants.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:water_project/models/customers.dart';

class CustomerTile extends StatefulWidget {
  final Customer customer;
  CustomerTile({this.customer});
  @override
  _CustomerTileState createState() => _CustomerTileState();
}

class _CustomerTileState extends State<CustomerTile> {
  bool positive = false;
  int collectedAmount = 0;

  int bottlesChange = 0;
  int bottlesOrdered;
  bool showMarkButton = false;
  final amountHolder = TextEditingController();
  final addAccountBalanceController = TextEditingController();
  final bottlesOrderedCustomerController = TextEditingController();
  int userAccount;
  getCustomerAccountAndBottlesOrdered() async {
    await Firestore.instance
        .collection('profiles')
        .document(widget.customer.uid)
        .get()
        .then((value) {
      setState(() {
        userAccount = value.data['account'];
        bottlesOrdered = value.data['bottlesOrdered'];
      });
    });
  }

  @override
  void initState() {
    getCustomerAccountAndBottlesOrdered();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int a = widget.customer.account;

    if (widget.customer.account > 0) {
      setState(() {
        positive = true;
      });
    } else {
      a *= -1;
    }

    return GestureDetector(
      onTap: () {
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
                              'Update Customer Data',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 40),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Change Account Balance: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  enabled: true,
                                  keyboardType: TextInputType.number,
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
                                        borderSide: BorderSide(
                                            color: Constants.BUTTON_TXT)),
                                    hintText: 'Use \'-\' for negative values',
                                    focusColor: Constants.BUTTON_TXT,
                                  ),
                                  controller: addAccountBalanceController,
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                              onPressed: () async {
                                if (addAccountBalanceController.text != null) {
                                  collectedAmount = int.tryParse(
                                      addAccountBalanceController.text);
                                  userAccount += collectedAmount;
                                  await Firestore.instance
                                      .collection('profiles')
                                      .document(widget.customer.uid)
                                      .updateData({'account': userAccount});
                                  addAccountBalanceController.clear();
                                  setState(() {
                                    collectedAmount = 0;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.BUTTON_BG,
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Text(
                                  'Update Account Balance',
                                  style: TextStyle(
                                    color: Constants.BUTTON_TXT,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Change Number of Bottles Ordered: ',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                TextField(
                                  keyboardType: TextInputType.number,
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
                                        borderSide: BorderSide(
                                            color: Constants.BUTTON_TXT)),
                                    hintText: 'Use \'-\' for negative values',
                                    focusColor: Constants.BUTTON_TXT,
                                  ),
                                  controller: bottlesOrderedCustomerController,
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                              onPressed: () async {
                                if (bottlesOrderedCustomerController.text !=
                                    null) {
                                  bottlesChange = int.tryParse(
                                      bottlesOrderedCustomerController.text);
                                  bottlesOrdered += bottlesChange;
                                  await Firestore.instance
                                      .collection('profiles')
                                      .document(widget.customer.uid)
                                      .updateData(
                                          {'bottlesOrdered': bottlesOrdered});
                                  bottlesOrderedCustomerController.clear();
                                  setState(() {
                                    bottlesChange = 0;
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.BUTTON_BG,
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 10),
                                child: Text(
                                  'Update Bottles Ordered',
                                  style: TextStyle(
                                    color: Constants.BUTTON_TXT,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
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
                      '${widget.customer.name}',
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
                          'Phone Number: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          '${widget.customer.phoneNumber}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          positive ? 'To pay: ' : 'To recieve: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          !positive ? '$a' : '${widget.customer.account}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                !positive ? Colors.green[500] : Colors.red[500],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Bottles Ordered: ',
                          style: TextStyle(
                              fontSize: 18, color: Colors.blueGrey[400]),
                        ),
                        Text(
                          '${widget.customer.bottlesOrdered}',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      onPressed: () {
                        UrlLauncher.launch(
                            'tel:${widget.customer.phoneNumber}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Constants.BUTTON_BG,
                            borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 10),
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
                  ]))),
    );
  }
}
