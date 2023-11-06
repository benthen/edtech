import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/unlockedCourse.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  final String courseName;
  final String mykad;
  final String coursePath;

  const CourseDetail({
    super.key,
    required this.courseName,
    required this.mykad,
    required this.coursePath,
  });

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  UserDatabase user = UserDatabase();

  Map<String, dynamic> detail = {};

  bool isReady = true;

  @override
  void initState() {
    super.initState();
    getCourseDetail();
  }

  void getCourseDetail() async {
    final data = await user.getCourseContent(widget.courseName.toLowerCase());
    final data1 = await user.getUserDetail(widget.mykad);
    setState(() {
      detail = data;
      isReady = false;
    });
    print(detail['point'].runtimeType);
    print(data1['edu_point'].runtimeType);
    print(detail['point'] - data1['edu_point']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 55, 0, 0),
                child: Text('${widget.courseName}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            SingleChildScrollView(
                child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 0, 0),
                child: Text(
                  "About this course",
                  style: TextStyle(fontSize: 25, color: Colors.grey),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: isReady
                          ? CircularProgressIndicator()
                          : Text(detail['description'],
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                    )),
              ),
              isReady
                  ? CircularProgressIndicator()
                  : Row(
                      children: [
                        SizedBox(width: 30),
                        Icon(Icons.edit),
                        Text("${detail['chapter'].toString()} chapters",
                            style: TextStyle(fontSize: 20)),
                        SizedBox(width: 30),
                        Icon(Icons.videocam),
                        Text("${detail['video'].toString()} videos",
                            style: TextStyle(fontSize: 20)),
                      ],
                    ),
              isReady
                  ? CircularProgressIndicator()
                  : Row(children: [
                SizedBox(width: 30),
                Icon(Icons.schedule),
                Text("${detail['month'].toString()} months",
                    style: TextStyle(fontSize: 20)),
                SizedBox(width: 40),
                Icon(Icons.grade),
                Text("${detail['point'].toString()} points",
                    style: TextStyle(fontSize: 20))
              ]),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final canUnlock =
                          await user.checkPoint(widget.mykad, detail['point'], widget.coursePath);
                      if (canUnlock) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UnlockedCoursePage(
                                    courseName: widget.courseName,
                                    mykad: widget.mykad, coursePath: widget.coursePath)));
                      } else {
                        showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            content: const Text(
                                'You don\'t have sufficient amount of points to unlock this course. Please finish the quiz of other courses first!'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CourseDetail(
                                              mykad: widget.mykad,
                                              courseName: widget.courseName, coursePath: widget.coursePath,
                                            ))),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      "Unlock Now!",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        fixedSize: const Size(300, 50)),
                  ),
                ],
              )
            ]))
          ],
        ),
      ),
    );
  }
}
