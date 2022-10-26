class Office {
  String key;
  double latitude;
  double longitude;
  String name;
  double radius;

  Office({
    required this.key,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.radius,
  });

  String get getName {
    return name;
  }

  double get getLatitude {
    return latitude;
  }

  double get getLongitude {
    return longitude;
  }

  double get getRadius {
    return radius;
  }

  String get getKey {
    return key;
  }

  factory Office.fromJson(String key, Map<String, dynamic> parsedJson) {
    return Office(
        key: key,
        name: parsedJson['name'],
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
        radius: parsedJson['radius']);
  }
}
