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
      'course_taken': 'english.jpg',
      'course_finish': '',
      'edu_point': 0,
      'english': 1,
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

  Future finishCourse(mykad, coursePath) async {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection("user");

    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('user').doc(mykad);

    final DocumentSnapshot documentSnapshot = await documentReference.get();
    String course = '';
    try {
      Map<String, dynamic> data =
          documentSnapshot.data()! as Map<String, dynamic>;
      var taken = '';
      if (data['course_taken'].split(', ').length > 1) {
        taken = data['course_taken'].replaceAll('$coursePath, ', "");
      } else {
        taken = "";
      }
      if (data['course_finish'] == '') {
        reference
            .doc(mykad)
            .update({"course_finish": coursePath, "course_taken": taken});
      } else {
        course = '${coursePath}, ${data['course_finish']}';
        reference
            .doc(mykad)
            .update({"course_finish": course, "course_taken": taken});
      }
    } catch (e) {}
  }

  Future<Map<String, dynamic>> getCourseContent(courseName) async {
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

  Future<bool> checkPoint(mykad, point, courseName) async {
    final data = await getUserDetail(mykad);
    if (data['edu_point'] - point >= 0) {
      final CollectionReference reference =
          FirebaseFirestore.instance.collection("user");
      final after = data['edu_point'] - point;
      if (data['course_taken'] == '') {
        reference.doc(mykad).update(
            {'edu_point': after, "course_taken": courseName, "biology": 1});
      } else {
        final taken = '${courseName}, ${data['course_taken']}';
        reference
            .doc(mykad)
            .update({'edu_point': after, "course_taken": taken, 'biology': 1});
      }
      return true;
    } else
      return false;
  }

  Future changeChapterProgress(mykad, courseName, progress) async {
    final CollectionReference reference =
        FirebaseFirestore.instance.collection("user");
    reference.doc(mykad).update({courseName: progress});
  }

  Future awardPoint(mykad) async {
    final data = await getUserDetail(mykad);
    final CollectionReference reference =
        FirebaseFirestore.instance.collection("user");
    reference.doc(mykad).update(
        {"edu_point": data['edu_point'] + 1000});
  }

  Future updateQuizResult(mykad, courseName, quizResult) async{
final CollectionReference reference =
        FirebaseFirestore.instance.collection("user");
        if(quizResult == 'PASSED')
    reference.doc(mykad).update(
        {courseName.toLowerCase(): 0});
        else if(quizResult == 'FAILED') reference.doc(mykad).update(
        {courseName.toLowerCase(): 1});
  }
}
