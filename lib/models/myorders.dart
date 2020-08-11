class MyOrders {
  String brand;
  int volume, amount, orderQuantity, paidAmount;
  bool delivered;

  MyOrders(
      {this.amount,
      this.brand,
      this.delivered,
      this.orderQuantity,
      this.paidAmount,
      this.volume});
}
