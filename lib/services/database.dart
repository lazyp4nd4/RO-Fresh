import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:water_project/models/customers.dart';
import 'package:water_project/models/orders.dart';
import 'package:water_project/models/products.dart';

class DatabaseServices {
  addData(String uid, String phone, String name) {
    Firestore.instance.collection('profiles').document(uid).setData({
      'phone number': phone,
      'uid': uid,
      'name': name,
      'isVendor': false,
      'account': 0,
      'bottlesOrdered': 0,
    });
  }

  addCustomer(name, phoneNo) async {
    DocumentReference docRef =
        Firestore.instance.collection('profiles').document();
    docRef.setData({
      'name': name,
      'uid': docRef.documentID,
      'isVendor': false,
      'phone number': phoneNo,
      'account': 0,
      'bottlesOrdered': 0,
    });
  }

  addProduct(capacity, price, brand) {
    DocumentReference docRef =
        Firestore.instance.collection('products').document();
    docRef.setData({
      'capacity': capacity,
      'price': price,
      'brand': brand,
      'productId': docRef.documentID,
      'time': DateTime.now().millisecondsSinceEpoch
    });
  }

  handleUserAccount(account, customerId) async {
    await Firestore.instance
        .collection('profiles')
        .document(customerId)
        .updateData({'account': account});
  }

  addPaidAmount(paidAmount, orderId) async {
    await Firestore.instance.collection('orders').document(orderId).updateData({
      'paidAmount': paidAmount,
    });
  }

  updateProduct(capacity, price, brand, productId) async {
    await Firestore.instance
        .collection('products')
        .document(productId)
        .updateData({
      'capacity': capacity,
      'brand': brand,
      'price': price,
    });
  }

  removeProduct(productId) async {
    await Firestore.instance
        .collection('products')
        .document(productId)
        .delete();
  }

  placeOrder(orderQuantity, uid, amount, capacity, brand) async {
    String phoneNumber, name;
    int bottlesOrdered;
    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .get()
        .then((value) {
      phoneNumber = value.data['phone number'];
      name = value.data['name'];
      bottlesOrdered = value.data['bottlesOrdered'];
    });
    bottlesOrdered += orderQuantity;
    DocumentReference docRef =
        Firestore.instance.collection('orders').document();
    await docRef.setData({
      'time': DateTime.now().millisecondsSinceEpoch,
      'brand': brand,
      'customerId': uid,
      'orderQuantity': orderQuantity,
      'phoneNumber': phoneNumber,
      'name': name,
      'delivered': false,
      'amount': amount,
      'orderId': docRef.documentID,
      'bottleType': capacity,
      'paidAmount': 0,
    });

    await Firestore.instance
        .collection('profiles')
        .document(uid)
        .updateData({'bottlesOrdered': bottlesOrdered});
  }

  markAsDone(orderId) async {
    await Firestore.instance
        .collection('orders')
        .document(orderId)
        .updateData({'delivered': true});
  }

  List<Order> _orderListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Order(
          brand: doc.data['brand'],
          orderQuantity: doc.data['orderQuantity'],
          customerId: doc.data['customerId'],
          paidAmount: doc.data['paidAmount'],
          name: doc.data['name'],
          isDelivered: doc.data['delivered'],
          amount: doc.data['amount'],
          phoneNumber: doc.data['phoneNumber'],
          orderId: doc.data['orderId'],
          bottleType: doc.data['bottleType']);
    }).toList();
  }

  Stream<List<Order>> get orders {
    return Firestore.instance
        .collection('orders')
        .where('delivered', isEqualTo: false)
        .orderBy('time', descending: false)
        .snapshots()
        .map(_orderListFromSnapshot);
  }

  List<Product> _productListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Product(
          capacity: doc.data['capacity'],
          price: doc.data['price'],
          productId: doc.data['productId'],
          brand: doc.data['brand']);
    }).toList();
  }

  Stream<List<Product>> get products {
    return Firestore.instance
        .collection('products')
        .orderBy('time', descending: true)
        .snapshots()
        .map(_productListFromSnapshots);
  }

  List<Customer> _customerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Customer(
          name: doc.data['name'],
          isVendor: doc.data['isVendor'],
          phoneNumber: doc.data['phone number'],
          bottlesOrdered: doc.data['bottlesOrdered'],
          uid: doc.data['uid'],
          account: doc.data['account']);
    }).toList();
  }

  Stream<List<Customer>> get customers {
    return Firestore.instance
        .collection('profiles')
        .where('isVendor', isEqualTo: false)
        .snapshots()
        .map(_customerListFromSnapshot);
  }
}
