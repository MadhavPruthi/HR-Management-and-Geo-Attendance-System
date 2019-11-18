import 'package:geo_attendance_system/src/ui/constants/attendance_type.dart';

class AttendanceList {
  DateTime dateTime;
  List<Attendance> attendanceList;

  AttendanceList({this.dateTime, this.attendanceList});

  DateTime get date {
    return dateTime;
  }

  List<Attendance> get listOfAttendance {
    return attendanceList;
  }

  AttendanceList.fromJson(dynamic dataSnapshot, String selectedDate) {
    List<Attendance> attendanceList = [];

    if (dataSnapshot != null) {
      dataSnapshot.cast<String, dynamic>().forEach((key, value) {
        attendanceType type = (key == "IN")
            ? attendanceType.IN
            : (key == "OUT" ? attendanceType.OUT : attendanceType.UNDETERMINED);
        String formattedString = selectedDate.split("-").reversed.join("-");
        formattedString = formattedString + " ${value["time"]}:00Z";
        DateTime time = DateTime.parse(formattedString);
        attendanceList
            .add(Attendance(type: type, time: time, office: value["office"]));
      });
    }
    this.attendanceList = attendanceList;
  }
}

class Attendance {
  attendanceType type;
  DateTime time;
  String office;

  Attendance({this.type, this.time, this.office});
}
