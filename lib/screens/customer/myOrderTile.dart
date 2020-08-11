import 'package:flutter/material.dart';

class MyOrderTile extends StatefulWidget {
  final String brand;
  final int volume, amount, orderQuantity, paidAmount;
  final bool delivered;

  MyOrderTile(
      {this.amount,
      this.brand,
      this.delivered,
      this.orderQuantity,
      this.paidAmount,
      this.volume});

  @override
  _MyOrderTileState createState() => _MyOrderTileState();
}

class _MyOrderTileState extends State<MyOrderTile> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2,
        margin: EdgeInsets.symmetric(horizontal: 35, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '${widget.brand}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Single bottle of ${widget.volume} L volume',
                    style: TextStyle(fontSize: 16, color: Colors.blueGrey[400]),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Quantity: ',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blueGrey[400]),
                          ),
                          Text(
                            '${widget.orderQuantity}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount: ',
                            style: TextStyle(
                                fontSize: 20, color: Colors.blueGrey[400]),
                          ),
                          Text(
                            '${widget.amount}',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  widget.delivered
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Amount Paid: ',
                              style: TextStyle(
                                  fontSize: 20, color: Colors.blueGrey[400]),
                            ),
                            Text(
                              '${widget.paidAmount}',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400),
                            )
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                            fontSize: 20, color: Colors.blueGrey[400]),
                      ),
                      widget.delivered
                          ? Text(
                              'Delivered',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.green[500],
                                  fontWeight: FontWeight.w400),
                            )
                          : Text(
                              'Not Delivered',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.amber[500],
                                  fontWeight: FontWeight.w400),
                            ),
                    ],
                  )
                ])));
  }
}
