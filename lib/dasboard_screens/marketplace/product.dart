class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String chatRoomId;
  final String? sellerId; // Make sellerId optional

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.chatRoomId,
    this.sellerId, // Optional sellerId
  });
}
