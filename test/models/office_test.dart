import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attendance_system/src/models/office.dart';

void main() {
  group('Office Model Tests', () {
    final String testKey = "office_key_123";
    final Map<String, dynamic> testJson = {
      'name': 'Test Office',
      'latitude': 12.345,
      'longitude': -67.890,
      'radius': 100.5,
    };

    test('Office.fromJson creates a valid Office object', () {
      final office = Office.fromJson(testKey, testJson);

      expect(office.key, testKey);
      expect(office.name, 'Test Office');
      expect(office.latitude, 12.345);
      expect(office.longitude, -67.890);
      expect(office.radius, 100.5);
    });

    test('Office getters return correct values', () {
      final office = Office(
        key: 'key_getter_test',
        name: 'Getter Office',
        latitude: 10.0,
        longitude: 20.0,
        radius: 50.0,
      );

      expect(office.getKey, 'key_getter_test');
      expect(office.getName, 'Getter Office');
      expect(office.getLatitude, 10.0);
      expect(office.getLongitude, 20.0);
      expect(office.getRadius, 50.0);
    });

    test('Office.fromJson handles null or missing optional fields gracefully', () {
      final Map<String, dynamic> partialJson = {
        'name': 'Partial Office',
        // latitude, longitude, radius are missing
      };
      final office = Office.fromJson("partial_key", partialJson);

      expect(office.key, "partial_key");
      expect(office.name, 'Partial Office');
      expect(office.latitude, null); // Or default value if defined in model
      expect(office.longitude, null); // Or default value if defined in model
      expect(office.radius, null); // Or default value if defined in model
    });
  });
}
