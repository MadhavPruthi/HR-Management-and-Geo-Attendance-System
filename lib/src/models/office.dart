class Office {
  double latitude;
  double longitude;
  String name;

  Office({this.name, this.latitude, this.longitude});

  factory Office.fromJson(String key, Map<String, dynamic> parsedJson){
    return Office(
        name: parsedJson['name'],
        latitude : parsedJson['latitude'],
        longitude : parsedJson ['longitude']
    );
  }
}
