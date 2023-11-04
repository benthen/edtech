import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserDatabase {
  Future userRegister(mykad, name, phone, email, race, password) async {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection('user');

    reference.doc(mykad).set({
      'mykad': mykad,
      'name': name,
      'password': password,
      'race': race,
      'email': email,
      'phone': phone,
      'course_taken': '',
      'course_finish': ''
    });
  }

  Future<bool> checkUser(mykad) async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(mykad);

    final DocumentSnapshot documentSnapshot = await documentReference.get();

    return documentSnapshot.exists;
  }

  Future<bool> userLogin(mykad, password) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('user').doc(mykad);

      final DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      if (data['password'] == password) {
        return true;
      } else
        return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserDetail(mykad) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('user').doc(mykad);

      final DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {};
    }
  }

  Future<List<Map>> getAllCourseImage() async {
    List<Map> files = [];

    final ListResult result =
        await FirebaseStorage.instance.ref().child('logo').list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final String fileType = file.name.split('.').last.toLowerCase();
      if (fileType == 'jpg' || fileType == 'jpeg' || fileType == 'png') {
        files.add({"url": fileUrl, "path": file.fullPath});
      }
    });

    return files;
  }

  Future<Map<String, dynamic>> getQuizDetail(course) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection(course).doc(course);

      final DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {};
    }
  }

  Future finishCourse(mykad, courseName) async {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection("user");

    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(mykad);

    final DocumentSnapshot documentSnapshot = await documentReference.get();
    String course = '';
    try {
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      if (data['course_finish'].toString() == '') {
        reference.doc(mykad).update({"course_finish": courseName});
      } else {
        course = '${courseName}, ${data['course_finish']}';
        reference.doc(mykad).update({"course_finish": course});
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getAllCourseDetail(courseName) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection(courseName).doc(courseName);

      final DocumentSnapshot documentSnapshot = await documentReference.get();
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      return data;
    } catch (e) {
      return {};
    }
  }
}
