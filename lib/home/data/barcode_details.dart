class BarcodeDetails {
  final String barcodeNumber;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  BarcodeDetails({
    required this.barcodeNumber,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  // Create an Event object from a Firestore document
  factory BarcodeDetails.fromJson(Map<String, dynamic> json) {
    return BarcodeDetails(
        barcodeNumber: json['barcodeNumber'] ?? '',
        name: json['title'] ?? '',
        description: json['description'] ?? '',
        price: double.parse((json['stores'][0]?["price"] ?? "0")),
        category: json['category'] ?? '',
        imageUrl: json["images"][0] ?? '');
  }
}
