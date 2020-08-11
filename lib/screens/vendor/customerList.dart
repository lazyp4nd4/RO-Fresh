import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:water_project/services/constants.dart';
import 'package:water_project/models/customers.dart';
import 'package:water_project/auth/register.dart';
import 'package:water_project/screens/vendor/customerTile.dart';
import 'package:water_project/services/authServices.dart';
import 'package:water_project/services/database.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  String name, phoneNo;
  int account = 0, bottlesOrdered = 0;

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<List<Customer>>(context);

    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Constants.BUTTON_TXT),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
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
                                  'Add Customer',
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 40),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'Name: ',
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
                                          hintText: 'Name',
                                          focusColor: Constants.BUTTON_TXT,
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            name = text;
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
                                          'Phone Number: ',
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
                                          hintText: 'Phone Number',
                                          focusColor: Constants.BUTTON_TXT,
                                        ),
                                        onChanged: (text) {
                                          setState(() {
                                            phoneNo = '+91' + text;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 20),
                                FlatButton(
                                  onPressed: () async {
                                    // String uri =
                                    //     'sms:$phoneNo?body:You have been added as a customer in RO Fresh!';

                                    await DatabaseServices()
                                        .addCustomer(name, phoneNo);
                                    Navigator.pop(context);
                                    // if (await UrlLauncher.canLaunch(uri)) {
                                    //   UrlLauncher.launch(uri);
                                    // } else {
                                    //   print('Could not send sms');
                                    // }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Constants.BUTTON_TXT,
                                        borderRadius:
                                            BorderRadius.circular(10)),
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
            color: Constants.BUTTON_TXT,
          ),
          backgroundColor: Constants.BUTTON_BG,
        ),
        appBar: AppBar(
          backgroundColor: Constants.BUTTON_TXT,
          actions: [
            IconButton(
              icon: Icon(
                Icons.settings_power,
                color: Constants.BUTTON_BG,
              ),
              onPressed: () {
                AuthService().signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ));
              },
            )
          ],
          elevation: 0,
          title: Text(
            'Customers',
            style: TextStyle(color: Constants.BUTTON_BG),
          ),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                return CustomerTile(
                  customer: customers[index],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
