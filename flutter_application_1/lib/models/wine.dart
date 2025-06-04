class Wine {
  final String name;
  final String region;
  final String country;
  final String price;
  final String imagePath;
  final String type;
  final String description;
  final double rating;

  Wine(
      {required this.name,
      required this.region,
      required this.country,
      required this.price,
      required this.imagePath,
      required this.type,
      required this.description,
      required this.rating});
}
