class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description; // New field for product description
  final String chatRoomId;
  final String? sellerId;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description, // Include the description in the constructor
    required this.chatRoomId,
    this.sellerId,
  });
}
