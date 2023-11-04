import 'package:edtech/user/eduPoint.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int result;
  final int length;
  final String courseName;
  final String mykad;
  const ResultPage(
      {super.key,
      required this.result,
      required this.length,
      required this.courseName, required this.mykad});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String url = '';
  bool isReady = true;

  @override
  void initState() {
    super.initState();
    getPicURL();
  }

  void getPicURL() async {
    String file = await FirebaseStorage.instance
        .ref()
        .child('logo/${widget.courseName}')
        .getDownloadURL();
    setState(() {
      url = file;
      isReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/star.jpg',
              ),
              fit: BoxFit.cover)),
      child: Column(
        children: [
          SizedBox(height: 160),
          Text("Congratulations!!!",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 50,
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("You have ",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold)),
              Text("PASSED ",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 40,
                      fontWeight: FontWeight.bold)),
              Text("the quiz!!!",
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold))
            ],
          ),
          Text(
            "Result: ${widget.result}/${widget.length}",
            style: TextStyle(
                color: Colors.green, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 10),
          isReady
              ? CircularProgressIndicator()
              : Container(
                  height: 210,
                  width: 270,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      blurRadius: 10.0,
                    ),
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
          SizedBox(height: 20),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4768FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.fromLTRB(100, 10, 100, 10)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EduPointPage(mykad: widget.mykad)));
              },
              child: Text("Save the badge", style: TextStyle(
                color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600),))
        ],
      ),
    ));
  }
}
