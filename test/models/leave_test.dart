import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attendance_system/src/models/leave.dart';
import 'package:geo_attendance_system/src/ui/constants/leave_type.dart';

void main() {
  group('Leave Model Helper Functions', () {
    test('formattedProperDateTime parses date string correctly', () {
      expect(formattedProperDateTime("01-01-2023"), DateTime(2023, 1, 1, 1, 0, 0));
      expect(formattedProperDateTime("31-12-2022"), DateTime(2022, 12, 31, 1, 0, 0));
    });

    test('getType returns correct LeaveType', () {
      expect(getType("al"), LeaveType.al);
      expect(getType("cl"), LeaveType.cl);
      expect(getType("ml"), LeaveType.ml);
      expect(getType("other"), LeaveType.undetermined);
      expect(getType(""), LeaveType.undetermined);
    });

    test('getStatus returns correct LeaveStatus', () {
      expect(getStatus("approved"), LeaveStatus.approved);
      expect(getStatus("pending"), LeaveStatus.pending);
      expect(getStatus("rejected"), LeaveStatus.rejected);
      expect(getStatus("other"), LeaveStatus.undetermined);
      expect(getStatus(""), LeaveStatus.undetermined);
    });
  });

  group('Leave Model Tests', () {
    final String testKey = "leave_key_123";
    final Map<String, dynamic> baseJson = {
      'appliedDate': "01-01-2023",
      'fromDate': "05-01-2023",
      'toDate': "10-01-2023",
      'type': "cl",
      'status': "pending",
      'withdrawalStatus': 0, // false
      'message': "Vacation",
      'name': 'Test User', // Assuming name and userUid are added to fromJson or handled
      'userUid': 'user_abc'
    };

    test('Leave.fromJson creates a valid Leave object with all fields', () {
      final leave = Leave.fromJson(testKey, baseJson);

      expect(leave.key, testKey);
      expect(leave.appliedDate, DateTime(2023, 1, 1, 1, 0, 0));
      expect(leave.fromDate, DateTime(2023, 1, 5, 1, 0, 0));
      expect(leave.toDate, DateTime(2023, 1, 10, 1, 0, 0));
      expect(leave.type, LeaveType.cl);
      expect(leave.status, LeaveStatus.pending);
      expect(leave.withdrawalStatus, false);
      expect(leave.message, "Vacation");
      // Note: The current Leave.fromJson in the codebase does not parse 'name' or 'userUid'.
      // If these were intended to be parsed, the model's fromJson would need an update.
      // For now, these will be null or whatever default the constructor sets.
      // expect(leave.name, 'Test User');
      // expect(leave.userUid, 'user_abc');
    });

    test('Leave.fromJson handles different leave types and statuses', () {
      final jsonApprovedAL = {
        ...baseJson,
        'type': "al",
        'status': "approved",
        'withdrawalStatus': 1, // true
      };
      final leaveApprovedAL = Leave.fromJson("key_al", jsonApprovedAL);
      expect(leaveApprovedAL.type, LeaveType.al);
      expect(leaveApprovedAL.status, LeaveStatus.approved);
      expect(leaveApprovedAL.withdrawalStatus, true);

      final jsonRejectedML = {
        ...baseJson,
        'type': "ml",
        'status': "rejected",
      };
      final leaveRejectedML = Leave.fromJson("key_ml", jsonRejectedML);
      expect(leaveRejectedML.type, LeaveType.ml);
      expect(leaveRejectedML.status, LeaveStatus.rejected);
    });

    test('Leave.fromJson handles empty message', () {
      final jsonEmptyMessage = {
        ...baseJson,
        'message': "",
      };
      final leave = Leave.fromJson("key_empty_msg", jsonEmptyMessage);
      expect(leave.message, "none");
    });

    test('Leave.fromJson uses default values from constructor for fields not in JSON', () {
      // The current Leave.fromJson in the provided code snippet does not directly use the
      // name and userUid from the JSON. They are parameters to the Leave constructor itself.
      // This test will verify what happens if those fields are not in the JSON,
      // assuming the constructor handles them (e.g. with default values or null).
      // The provided fromJson does not assign name/userUid from parsedJson.

      final Map<String, dynamic> minimalJson = {
        'appliedDate': "02-02-2023",
        'fromDate': "06-02-2023",
        'toDate': "11-02-2023",
        'type': "al",
        'status': "pending",
        'withdrawalStatus': 0,
        'message': "Minimal",
        // 'name' and 'userUid' are not in this JSON
      };

      // If the factory constructor was Leave.fromJson(key, parsedJson, name, userUid)
      // then we would pass them here. But it's Leave.fromJson(key, parsedJson)
      // and the factory then calls the main constructor.
      // The current Leave.fromJson doesn't pass name/userUid to the main Leave constructor
      // from the json, so they will be null unless the main constructor has defaults.
      final leave = Leave.fromJson("key_minimal", minimalJson);

      expect(leave.key, "key_minimal");
      expect(leave.appliedDate, DateTime(2023, 2, 2, 1, 0, 0));
      // Check fields that are parsed
      expect(leave.type, LeaveType.al);
      expect(leave.status, LeaveStatus.pending);

      // Fields not in JSON and not explicitly set by fromJson will be null
      // as per the default constructor behavior unless it specifies defaults.
      // The current Leave constructor in the snippet has these as named optional parameters.
      expect(leave.name, null);
      expect(leave.userUid, null);
    });

  });
}
