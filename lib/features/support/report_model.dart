class TrafficReport {
  final String issueType;
  final String description;
  final double latitude;
  final double longitude;
  final String imagePath;
  final DateTime createdAt;

  TrafficReport({
    required this.issueType,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.imagePath,
    required this.createdAt,
  });
}
