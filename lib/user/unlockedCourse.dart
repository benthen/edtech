import 'package:edtech/user/courseContent.dart';
import 'package:edtech/user/userHome.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UnlockedCoursePage extends StatefulWidget {
  final String courseName;
  final String mykad;
  final String coursePath;
  const UnlockedCoursePage(
      {super.key,
      required this.courseName,
      required this.mykad,
      required this.coursePath});

  @override
  State<UnlockedCoursePage> createState() => _UnlockedCoursePageState();
}

class _UnlockedCoursePageState extends State<UnlockedCoursePage> {
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
        child: isReady
            ? CircularProgressIndicator()
            : Column(
                children: [
                  SizedBox(height: 180),
                  Container(
                    height: 210,
                    width: 270,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        url,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "UNLOCKED SUCCESSFULLY",
                    style: TextStyle(
                        color: Colors.purple,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
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
                                builder: (context) => CourseChapter(
                                      mykad: widget.mykad,
                                      courseName: widget.courseName,
                                      coursePath: widget.coursePath,
                                      progress: 1,
                                    )));
                        CourseChapter(
                          mykad: widget.mykad,
                          courseName: widget.courseName,
                          coursePath: widget.coursePath,
                          progress: 1,
                        );
                      },
                      child: Text("Start Learning",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold))),
                  SizedBox(
                    height: 20,
                  ),
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
                        "Back to Home",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
      ),
    );
  }
}
