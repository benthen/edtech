import 'package:edtech/user/userHome.dart';
import 'package:edtech/user/quiz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int result;
  final int length;
  final String coursePath;
  final String courseName;
  final String mykad;
  final String quizResult;
  const ResultPage(
      {super.key,
      required this.result,
      required this.length,
      required this.coursePath,
      required this.courseName,
      required this.mykad,
      required this.quizResult});

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
        .child('logo/${widget.coursePath}')
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
          SizedBox(height: 190),
          if (widget.quizResult == 'PASSED') ...[
            Text("Congratulations!!!",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You have ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text("${widget.quizResult} ",
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Text("the quiz!!!",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
            Text(
              "Result: ${widget.result}/${widget.length}",
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 20),
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
          ] else if (widget.quizResult == 'FAILED') ...[
            Text("Unfortunately",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 40,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("You have ",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                Text("${widget.quizResult} ",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                Text("the quiz!!!",
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold))
              ],
            ),
            Text(
              "Result: ${widget.result}/${widget.length}",
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
          SizedBox(height: 40),
          widget.quizResult == 'FAILED'
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4768FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.fromLTRB(80, 10, 80, 10)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuizPage(
                                index: 0,
                                total: 0,
                                courseName: widget.courseName,
                                coursePath: widget.coursePath,
                                mykad: widget.mykad)));
                  },
                  child: Text(
                    "Retake the quiz",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ))
              : SizedBox(),
          SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4768FF),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  fixedSize: const Size(300, 50)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            UserHomePage(mykad: widget.mykad)));
              },
              child: Text(
                "Back to home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ))
        ],
      ),
    ));
  }
}
