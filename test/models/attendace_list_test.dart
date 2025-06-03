import 'package:flutter_test/flutter_test.dart';
import 'package:geo_attendance_system/src/models/AttendaceList.dart'; // Original filename
import 'package:geo_attendance_system/src/ui/constants/attendance_type.dart';

void main() {
  group('Attendance Model Tests', () {
    test('Attendance constructor assigns values correctly', () {
      final time = DateTime(2023, 1, 1, 9, 0, 0);
      final attendance = Attendance(
        type: attendanceType.IN,
        time: time,
        office: 'Main Office',
      );

      expect(attendance.type, attendanceType.IN);
      expect(attendance.time, time);
      expect(attendance.office, 'Main Office');
    });
  });

  group('AttendanceList Model Tests', () {
    // Mock data similar to what Firebase DataSnapshot might provide
    final Map<String, dynamic> mockFirebaseData = {
      "in-somehash1": {"time": "09:00:00", "office": "office_id_1"},
      "out-somehash2": {"time": "17:30:00", "office": "office_id_1"},
      "in-somehash3": {"time": "10:15:00", "office": "office_id_2"},
    };

    final Map<String, dynamic> emptyFirebaseData = {};

    final Map<String, String> officeMap = {
      "office_id_1": "Main Office",
      "office_id_2": "Branch Office",
    };

    final String selectedDate = "01-01-2023"; // DD-MM-YYYY format as expected by the model

    test('AttendanceList.fromJson parses valid data correctly', () {
      final attendanceListModel = AttendanceList.fromJson(mockFirebaseData, selectedDate, officeMap);
      final attendances = attendanceListModel.listOfAttendance;

      expect(attendances.length, 3);

      // Attendance 1
      expect(attendances[0].type, attendanceType.IN);
      expect(attendances[0].time, DateTime(2023, 1, 1, 9, 0, 0)); // Parsed from "2023-01-01 09:00:00"
      expect(attendances[0].office, "Main Office");

      // Attendance 2
      expect(attendances[1].type, attendanceType.OUT);
      expect(attendances[1].time, DateTime(2023, 1, 1, 17, 30, 0));
      expect(attendances[1].office, "Main Office");

      // Attendance 3
      expect(attendances[2].type, attendanceType.IN);
      expect(attendances[2].time, DateTime(2023, 1, 1, 10, 15, 0));
      expect(attendances[2].office, "Branch Office");
    });

    test('AttendanceList.fromJson handles empty data snapshot', () {
      final attendanceListModel = AttendanceList.fromJson(emptyFirebaseData, selectedDate, officeMap);
      expect(attendanceListModel.listOfAttendance.isEmpty, true);
    });

    test('AttendanceList.fromJson handles null data snapshot', () {
      final attendanceListModel = AttendanceList.fromJson(null, selectedDate, officeMap);
      expect(attendanceListModel.listOfAttendance.isEmpty, true);
    });

    test('AttendanceList.fromJson handles undetermined attendance type', () {
      final Map<String, dynamic> dataWithUndetermined = {
        "unknown-hash": {"time": "12:00:00", "office": "office_id_1"}
      };
      final attendanceListModel = AttendanceList.fromJson(dataWithUndetermined, selectedDate, officeMap);
      expect(attendanceListModel.listOfAttendance.length, 1);
      expect(attendanceListModel.listOfAttendance[0].type, attendanceType.UNDETERMINED);
      expect(attendanceListModel.listOfAttendance[0].time, DateTime(2023,1,1,12,0,0));
      expect(attendanceListModel.listOfAttendance[0].office, "Main Office");
    });

    test('AttendanceList getters work correctly', () {
      final now = DateTime.now();
      final attendance = Attendance(type: attendanceType.IN, time: now, office: "Test");
      final attendanceList = AttendanceList(dateTime: now, attendanceList: [attendance]);

      expect(attendanceList.date, now);
      expect(attendanceList.listOfAttendance.length, 1);
      expect(attendanceList.listOfAttendance[0], attendance);
    });

  });
}
