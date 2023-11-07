import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class AdminDatabase {
  Future<bool> adminLogin(id, password) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('admin').doc(id);

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

  Future createCourse(name, desc, chapter, month, point, video) async {
    String lower = name.toLowerCase();
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(lower);

    reference.doc(lower).set({
      'name': name,
      'description': desc,
      'chapter': chapter,
      'month': month,
      'point': point,
      'video': video,
    });
  }

  Future<bool> checkCourseExist(name) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection(name).doc(name);

      final DocumentSnapshot documentSnapshot = await documentReference.get();

      return documentSnapshot.exists;
    } catch (e) {
      return false;
    }
  }

  Future createChapter(key, topic, name) async{
    final CollectionReference reference =
        FirebaseFirestore.instance.collection(name);

    reference.doc(name).update({key:topic});
  }

  Future<String> uploadCourseLogo(name) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);

      final path = '${name.toLowerCase()}.${basename(file.path.split('.').last)}';

      final ref =
          FirebaseStorage.instance.ref().child('logo/$path');

      ref.putFile(file);


      return path;
    } else {
      return 'No image';
    }
  }
}
