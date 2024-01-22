// product.dart

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String chatRoomId;
  final String sellerId;
  final String sellerEmail; // Add sellerEmail property

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.chatRoomId,
    required this.sellerId,
    this.sellerEmail = 'Unknown', // Provide a default value
  });
}
