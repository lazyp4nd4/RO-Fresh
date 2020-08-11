import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:water_project/services/constants.dart';
import 'package:water_project/screens/loading.dart';
import 'package:water_project/auth/register.dart';
import 'package:water_project/services/authServices.dart';

class ProfileCustomer extends StatefulWidget {
  @override
  _ProfileCustomerState createState() => _ProfileCustomerState();
}

class _ProfileCustomerState extends State<ProfileCustomer> {
  String name, phoneNumber;
  int bottlesOrdered;
  int account;
  bool positive = true;
  String vendorPhoneNumber;
  String phone = '+919654764155';

  Future<void> getVendorPhoneNumber() async {
    await Firestore.instance
        .collection('profiles')
        .where('isVendor', isEqualTo: true)
        .getDocuments()
        .then((value) {
      value.documents.forEach((element) {
        setState(() {
          vendorPhoneNumber = element.data['phone number'];
        });
      });
    });
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> setProfileDetails() async {
    String uid = await getCurrentUser();
    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data['name'];
        phoneNumber = value.data['phone number'];
        account = value.data['account'];
        bottlesOrdered = value.data['bottlesOrdered'];
      });
      if (value.data['account'] >= 0) {
        setState(() {
          positive = true;
        });
      } else {
        setState(() {
          positive = false;
        });
      }
    });
  }

  @override
  void initState() {
    getVendorPhoneNumber();
    setProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Constants.BUTTON_TXT),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.BUTTON_TXT,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: account == null
            ? Loading(
                color: Constants.BUTTON_BG,
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              '$name',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Phone Number: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueGrey[400]),
                                ),
                                Text(
                                  '$phoneNumber',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Bottles Ordered: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueGrey[400]),
                                ),
                                Text(
                                  '$bottlesOrdered',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                )
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Account Balance: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blueGrey[400]),
                                ),
                                Text(
                                  positive ? '+ $account' : '$account',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: positive
                                        ? Colors.green[400]
                                        : Colors.red[400],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      margin:
                          EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Contact vendor:',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey[400]),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FlatButton(
                              onPressed: () {
                                UrlLauncher.launch('tel:$vendorPhoneNumber');
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Constants.BUTTON_TXT,
                                    borderRadius: BorderRadius.circular(10)),
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  'Call Mobile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 40),
                        child: FlatButton(
                          onPressed: () {
                            AuthService().signOut();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Register(),
                                ));
                          },
                          child: Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                horizontal: 35, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Text(
                                'LOGOUT',
                                style: TextStyle(
                                    color: Constants.BUTTON_TXT,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
      ),
    );
  }
}
