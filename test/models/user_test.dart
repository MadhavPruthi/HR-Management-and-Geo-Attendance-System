import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attendance_system/src/models/user.dart';
import 'package:geo_attendance_system/src/models/office.dart';

// Simple mock for DataSnapshot
class MockDataSnapshot {
  final dynamic _value; // Can be Map or primitive
  final String? key; // Mocking snapshot key

  MockDataSnapshot(this._value, {this.key = 'mock_snapshot_key'});

  dynamic get value => _value;
}

void main() {
  // Test Office instance to be used
  final testOffice = Office(
    key: 'office1',
    name: 'Main Office',
    latitude: 10.0,
    longitude: 10.0,
    radius: 100.0,
  );

  // Data that would be used to create an Employee object directly
  Employee createTestEmployee() {
    return Employee(
      uID: "testUID",
      employeeID: "E123",
      firstName: "John",
      middleName: "M.",
      lastName: "Doe",
      officeEmail: "john.doe@example.com",
      alternateEmail: "johnd@gmail.com",
      contactNumber: "1234567890",
      dateOfBirth: DateTime(1990, 1, 1),
      joiningDate: DateTime(2020, 5, 15),
      residentialAddress: "123 Main St",
      gender: Gender.Male,
      retirementAge: 65,
      joiningUnit: testOffice, // Assign the Office object
      skillCategory: SkillCategory.Skilled,
      employeeFunction: EmployeeFunction.ADD_HERE, // Using placeholder
      employeeSubFunction: EmployeeSubFunction.ADD_HERE, // Using placeholder
      grade: Grade.ADD_HERE, // Using placeholder
      designation: "Software Engineer",
      maritalStatus: MaritalStatus.Married,
      religion: Religion.Atheist,
      nationality: Nationality.American,
      entity: Entity.ADD_HERE, // Using placeholder
      bloodGroup: BloodGroup.O_positive,
      employeeType: EmployeeType.Manager,
      reviewPerson: null,
      role: Role.ADD_HERE, // Using placeholder
    );
  }

  // Data representing what comes from Firebase (used for fromSnapshot)
  final Map<String, dynamic> firebaseSnapshotData = {
    "UID": "user_xyz",
    "employeeID": "E456",
    "firstName": "Jane",
    "middleName": "K.",
    "lastName": "Doe",
    "officeEmail": "jane.doe@example.com",
    "alternateEmail": "janek@gmail.com",
    "contactNumber": "0987654321",
    "dateOfBirth": DateTime(1992, 3, 3).toIso8601String(), // Stored as ISO string
    "joiningDate": DateTime(2021, 6, 16).toIso8601String(), // Stored as ISO string
    "residentialAddress": "456 Other St",
    "gender": Gender.Female.toString(), // Stored as "Gender.Female"
    "retirementAge": 66,
    "joiningUnit": { // Office stored as a map
      'key': 'office2',
      'name': 'Branch Office',
      'latitude': 12.0,
      'longitude': -12.0,
      'radius': 200.0
    },
    "skillCategory": SkillCategory.Unskilled.toString(),
    "employeeFunction": EmployeeFunction.ADD_HERE.toString(),
    "employeeSubFunction": EmployeeSubFunction.ADD_HERE.toString(),
    "grade": Grade.ADD_HERE.toString(),
    "designation": "QA Engineer",
    "maritalStatus": MaritalStatus.Unmarried.toString(),
    "religion": Religion.Christianity.toString(),
    "nationality": Nationality.Canadian.toString(),
    "entity": Entity.ADD_HERE.toString(),
    "bloodGroup": BloodGroup.A_negative.toString(),
    "employeeType": EmployeeType.Trainee.toString(),
    "reviewPerson": null, // Assuming not populated or simple
    "role": Role.ADD_HERE.toString(),
  };


  group('Employee Model Tests', () {
    test('Employee can be instantiated with all nullable fields', () {
      final employee = createTestEmployee();
      expect(employee.firstName, "John");
      expect(employee.dateOfBirth, DateTime(1990, 1, 1));
      expect(employee.gender, Gender.Male);
      expect(employee.joiningUnit?.name, "Main Office");
      expect(employee.uID, "testUID");
    });

    test('Employee.toJson creates a correct map with ISO dates and enum strings', () {
      final employee = createTestEmployee();
      final json = employee.toJson();

      expect(json['employeeID'], "E123");
      expect(json['firstName'], "John");
      expect(json['dateOfBirth'], DateTime(1990, 1, 1).toIso8601String()); // Expect ISO string
      expect(json['gender'], Gender.Male.toString()); // Expect "Gender.Male"

      // Test nested Office object serialization
      expect(json['joiningUnit'], isA<Map<String, dynamic>>());
      expect(json['joiningUnit']['name'], "Main Office");
      expect(json['joiningUnit']['key'], "office1");
    });

    test('Employee.toJson handles null fields gracefully', () {
      final employee = Employee(firstName: "Minimal"); // Only one field
      final json = employee.toJson();

      expect(json['firstName'], "Minimal");
      expect(json['lastName'], null);
      expect(json['dateOfBirth'], null);
      expect(json['gender'], null);
      expect(json['joiningUnit'], null);
    });

    group('Employee.fromSnapshot', () {
      final mockSnapshot = MockDataSnapshot(firebaseSnapshotData, key: "user_xyz_snapshot_key");

      test('parses basic string, int, and bool fields correctly', () {
        final employee = Employee.fromSnapshot(mockSnapshot);
        expect(employee.uID, "user_xyz");
        expect(employee.employeeID, "E456");
        expect(employee.firstName, "Jane");
        expect(employee.retirementAge, 66);
        expect(employee.contactNumber, "0987654321");
        expect(employee.residentialAddress, "456 Other St");
      });

      test('parses DateTime fields from ISO8601 strings', () {
        final employee = Employee.fromSnapshot(mockSnapshot);
        expect(employee.dateOfBirth, DateTime(1992, 3, 3));
        expect(employee.joiningDate, DateTime(2021, 6, 16));
      });

      test('parses Enum fields from string representations', () {
        final employee = Employee.fromSnapshot(mockSnapshot);
        expect(employee.gender, Gender.Female);
        expect(employee.skillCategory, SkillCategory.Unskilled);
        expect(employee.maritalStatus, MaritalStatus.Unmarried);
        expect(employee.religion, Religion.Christianity);
        expect(employee.nationality, Nationality.Canadian);
        expect(employee.bloodGroup, BloodGroup.A_negative);
        expect(employee.employeeType, EmployeeType.Trainee);
        // Test a few enums with ADD_HERE placeholder if their string value is "EmployeeFunction.ADD_HERE" etc.
        expect(employee.employeeFunction, EmployeeFunction.ADD_HERE);
      });

      test('parses nested Office object using Office.fromJson', () {
        final employee = Employee.fromSnapshot(mockSnapshot);
        expect(employee.joiningUnit, isA<Office>());
        expect(employee.joiningUnit?.key, 'office2');
        expect(employee.joiningUnit?.name, 'Branch Office');
        expect(employee.joiningUnit?.latitude, 12.0);
      });

      test('handles missing optional fields gracefully (sets them to null)', () {
        final partialData = { ...firebaseSnapshotData };
        partialData.remove('middleName');
        partialData.remove('alternateEmail');
        final snapshotWithMissing = MockDataSnapshot(partialData);
        final employee = Employee.fromSnapshot(snapshotWithMissing);

        expect(employee.middleName, null);
        expect(employee.alternateEmail, null);
      });

      test('handles completely null joiningUnit from snapshot', () {
        final dataWithNullOffice = Map<String, dynamic>.from(firebaseSnapshotData);
        dataWithNullOffice['joiningUnit'] = null;
        final snapshot = MockDataSnapshot(dataWithNullOffice);
        final employee = Employee.fromSnapshot(snapshot);
        expect(employee.joiningUnit, null);
      });

      test('handles joiningUnit map missing a key field (uses snapshot key as fallback)', () {
        final Map<String, dynamic> officeDataMissingKey = {
          // 'key': 'office_key_is_missing', // Key is missing
          'name': 'Office Missing Key',
          'latitude': 15.0,
          'longitude': -15.0,
          'radius': 250.0
        };
        final dataWithOfficeMissingKey = Map<String, dynamic>.from(firebaseSnapshotData);
        dataWithOfficeMissingKey['joiningUnit'] = officeDataMissingKey;

        final snapshot = MockDataSnapshot(dataWithOfficeMissingKey, key: "employee_snapshot_key_for_office");
        final employee = Employee.fromSnapshot(snapshot);

        expect(employee.joiningUnit, isA<Office>());
        // The refactored fromSnapshot uses snapshot.key if officeMap['key'] is null
        expect(employee.joiningUnit?.key, 'employee_snapshot_key_for_office');
        expect(employee.joiningUnit?.name, 'Office Missing Key');
      });

    });
  });
}
