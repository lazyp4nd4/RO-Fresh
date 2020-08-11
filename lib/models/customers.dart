class Customer {
  String name;
  String phoneNumber;
  int account;
  bool isVendor;
  int bottlesOrdered;
  String uid;

  Customer(
      {this.account,
      this.bottlesOrdered,
      this.name,
      this.phoneNumber,
      this.uid,
      this.isVendor});
}
