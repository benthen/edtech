import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDatabase{
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
}