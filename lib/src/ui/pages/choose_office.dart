import 'package:flutter/material.dart';

//Widget dropDownMenuOffices() {
//  OfficeDatabase officeDatabase = new OfficeDatabase();
//  return FutureBuilder(
//    future: officeDatabase.getOfficeList(),
//    builder: (BuildContext context, AsyncSnapshot snapshot) {
//      if (snapshot.connectionState == ConnectionState.done) {
//        if (snapshot.data != null) {
//          return Container(
//            padding: EdgeInsets.symmetric(horizontal: 20),
//            child: InputDecorator(
//              decoration: InputDecoration(
//                  border: OutlineInputBorder(
//                      borderRadius: BorderRadius.circular(5.0))),
//              child: DropdownButtonHideUnderline(
//                child: DropdownButton(
//                  value: _selected,
//                  hint: Text('Select Office'),
//                  items: snapshot.data
//                      .map<DropdownMenuItem<Office>>((Office office) {
//                    return DropdownMenuItem<Office>(
//                      child: Text(office.name),
//                      value: office,
//                    );
//                  }).toList(),
//                  onChanged: (value) {
//                    setState(() {
//                      _selected = value;
//                    });
//                  },
//                ),
//              ),
//            ),
//          );
//        } else
//          return Text("${snapshot.error}");
//      } else {
//        return LinearProgressIndicator();
//      }
//    },
//  );
//}

class ChooseOfficeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ChooseOfficeWidgetState();
  }
}

class ChooseOfficeWidgetState extends State<ChooseOfficeWidget> {
  int _currentIndex = 0;
  final List<Widget> _children = [];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your office"),
        leading: Icon(Icons.bookmark_border),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mail),
            label: 'Messages',
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          )
        ],
      ),
    );
  }
}
