class Product {
  final int id;
  final String name;
  final String price;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      // On s'assure de convertir l'ID en int
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      price: json['price'],
      description: json['description'],
      imageUrl: json['image_url'],
    );
  }
}
