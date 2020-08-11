class Order {
  String name;
  String phoneNumber;
  String brand;
  bool isDelivered;
  int paidAmount;
  int orderQuantity;
  int amount;
  String orderId;
  int bottleType;
  String customerId;

  Order(
      {this.isDelivered,
      this.customerId,
      this.paidAmount,
      this.brand,
      this.name,
      this.orderQuantity,
      this.phoneNumber,
      this.amount,
      this.orderId,
      this.bottleType});
}
