class Challan {
  final String title;
  final String location;
  final String date;
  final String amount;
  final bool isPaid;
  final String? paymentId;

  Challan({
    required this.title,
    required this.location,
    required this.date,
    required this.amount,
    this.isPaid = false,
    this.paymentId,
  });
}
