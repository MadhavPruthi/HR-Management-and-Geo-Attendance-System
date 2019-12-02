import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geo_attendance_system/src/models/user.dart';

class UserDatabase
{


  //final FirebaseDatabase _db = FirebaseDatabase.instance;
 static final  _databasereference = FirebaseDatabase.instance.reference();
 static final UserDatabase _instance = UserDatabase._internal();

  factory UserDatabase()
  {
    return _instance;
  }

  UserDatabase._internal();

 static Future<DataSnapshot> getDetailsFromUID(String uid) async {
   DataSnapshot dataSnapshot =
   await _databasereference.child("users").child(uid).once();
   final profile = dataSnapshot.value[uid];
   final name = profile["name"];
   final latitude = profile["latitude"];
   final longitude = profile["longitude"];
   final radius = profile["radius"].toDouble();
   return EmployeeProfile(
       key: uid,
   );
 }
   return dataSnapshot;
 }


 }
  /*  final String path;
  CollectionReference ref;

  Api( this.path ) {
    ref = _db.collection(path);
  }

  Future<QuerySnapshot> getDataCollection() {
    return ref.getDocuments() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.document(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.document(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.document(id).updateData(data) ;
  }
*/

}