import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/courseDetail.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MainPageUiWidget extends StatefulWidget {
  final String mykad;
  const MainPageUiWidget({super.key, required this.mykad});

  @override
  _MainPageUiWidgetState createState() => _MainPageUiWidgetState();
}

class _MainPageUiWidgetState extends State<MainPageUiWidget> {
  UserDatabase user = UserDatabase();

  Map<String, dynamic> userDetail = {};
  List<Map> courseTaken = [];
  List<Map> remainingCourse = [];

  List<Map> courseTakenDetail = [];
  List<Map> remainingCourseDetail = [];

  bool firstReady = true;
  bool secondReady = true;

  @override
  void initState() {
    super.initState();
    getUserName();
    getCourseTakenFile();
  }

  void getUserName() async {
    final detail = await user.getUserDetail(widget.mykad);
    setState(() {
      userDetail = detail;
    });
  }

  void getCourseTakenFile() async {
    final file = await user.getAllCourseImage();
    setState(() {
      var courseTakenFiles = file;
      List<String> courseTakenMap = userDetail['course_taken'].split(', ');
      for (int i = 0; i < courseTakenMap.length; i++) {
        for (int j = 0; j < courseTakenFiles.length; j++) {
          if (basename(courseTakenFiles[j]['path']).split('.')[0] ==
              courseTakenMap[i]) {
            courseTaken.add({
              'url': courseTakenFiles[j]['url'].toString(),
              'path': basename(courseTakenFiles[j]['path'])
            });
            courseTakenFiles.removeAt(j);
            break;
          }
        }
      }
      for (int i = 0; i < courseTakenFiles.length; i++) {
        remainingCourse.add({'url': courseTakenFiles[i]['url'].toString(),
              'path': basename(courseTakenFiles[i]['path'])});
      }
      firstReady = false;
    });
    getAllCourseDetail(courseTaken, remainingCourse);
  }

  void getAllCourseDetail(taking, remaining) async {
    List<Map> dummy1 = [];
    List<Map> dummy2 = [];
    for (int i = 0; i < taking.length; i++) {
      var data = await user.getAllCourseDetail(taking[i]['path'].split('.')[0]);
      dummy1.add({'name': data['name'], 'description': data['description']});
    }
    for (int i = 0; i < remaining.length; i++) {
      var data =
          await user.getAllCourseDetail(remaining[i]['path'].split('.')[0]);
      dummy2.add({'name': data['name'], 'description': data['description']});
    }
    setState(() {
      courseTakenDetail = dummy1;
      remainingCourseDetail = dummy2;
      secondReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          height: 120,
          decoration: BoxDecoration(color: Colors.blue),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(10, 40, 0, 0),
                child: Text(
                  "Welcome ${userDetail['name']}",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(30, 35, 0, 0),
                  child: Container(
                    height: 50,
                    width: 110,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Edu_Points",
                                style: TextStyle(color: Colors.white)),
                            Text("+2400",
                                style: TextStyle(color: Colors.white)),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
        SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
            child: Text(
              "Currently taking courses",
              style: TextStyle(color: Colors.grey, fontSize: 25),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 400,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: courseTaken.length,
                      itemBuilder: (BuildContext cts, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetail(
                                          courseName: basename(
                                              courseTaken[index]['path']),
                                          mykad: widget.mykad,
                                        )));
                          },
                          child: firstReady && secondReady
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 166,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            courseTaken[index]['url'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.all(8.0),
                                      //   child: Text(
                                      //     courseTakenDetail[index]['name'],
                                      //     style: TextStyle(
                                      //         color: Colors.white,
                                      //         fontWeight: FontWeight.bold,
                                      //         fontSize: 30),
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            courseTakenDetail[index]
                                                ['description'],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      }),
                )),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: 400,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 20),
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.5,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 20.0,
                      ),
                      itemCount: remainingCourse.length,
                      itemBuilder: (BuildContext cts, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CourseDetail(
                                          courseName: basename(
                                              remainingCourse[index]['path']),
                                          mykad: widget.mykad,
                                        )));
                          },
                          child: firstReady && secondReady
                              ? CircularProgressIndicator()
                              : Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 150,
                                        width: 166,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            remainingCourse[index]['url'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          remainingCourseDetail[index]['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            remainingCourseDetail[index]
                                                ['description'],
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                            textAlign: TextAlign.left),
                                      ),
                                    ],
                                  ),
                                ),
                        );
                      }),
                )),
          )
        ]))
      ],
    )));
  }
}
