import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/courseContent.dart';
import 'package:edtech/user/courseDetail.dart';
import 'package:edtech/user/eduPoint.dart';
import 'package:edtech/user/profile.dart';
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
  int currentPageIndex = 1;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  void getUserName() async {
    final detail = await user.getUserDetail(widget.mykad);
    setState(() {
      userDetail = detail;
    });
    getCourseTakenFile(detail);
  }

  void getCourseTakenFile(detail) async {
    final file = await user.getAllCourseImage();
    setState(() {
      var courseTakenFiles = file;
      List<String> courseTakenMap = detail['course_taken'].split(', ');
      List<String> courseFinish = detail['course_finish'].split(', ');
      for (int i = 0; i < courseTakenMap.length; i++) {
        for (int j = 0; j < courseTakenFiles.length; j++) {
          if (basename(courseTakenFiles[j]['path']).split('.')[0] ==
              courseTakenMap[i].split('.')[0]) {
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
        remainingCourse.add({
          'url': courseTakenFiles[i]['url'].toString(),
          'path': basename(courseTakenFiles[i]['path'])
        });
      }
      for (int i = 0; i < courseFinish.length; i++) {
        for (int j = 0; j < remainingCourse.length; j++) {
          if (basename(remainingCourse[j]['path']).split('.')[0] ==
              courseFinish[i].split('.')[0]) {
            
            remainingCourse.removeAt(j);
            break;
          }
        }
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
        bottomNavigationBar: NavigationBar(
          height: 55,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          indicatorColor: Colors.blue,
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.star, size: 30),
              label: 'Reward',
            ),
            NavigationDestination(
              icon: Icon(Icons.home_outlined, size: 30),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_sharp, size: 30),
              label: 'Profile',
            ),
          ],
        ),
        body: <Widget>[
          EduPointPage(mykad: widget.mykad),
          SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(color: Colors.blue),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 60, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      Text(
                        "${userDetail['name']}",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
                      child: Text(
                        "Currently taking courses",
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: ((courseTaken.length + 1)/2).ceil() * 400,
                          width: MediaQuery.of(context).size.width,
                          child: courseTaken.isEmpty &&
                                  courseTakenDetail.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                      "You are not taking any course now",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500)),
                                )
                              : Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 20),
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
                                                    builder: (context) =>
                                                        CourseChapter(
                                                            mykad:
                                                               widget.mykad,
                                                            courseName:
                                                                courseTakenDetail[
                                                                        index]
                                                                    ['name'],
                                                            coursePath:
                                                                courseTaken[
                                                                        index]
                                                                    ['path'],
                                                            progress: userDetail[courseTakenDetail[index]['name'].toLowerCase()])));
                                          },
                                          child: (remainingCourseDetail
                                                      .isEmpty ||
                                                  remainingCourse.isEmpty ||
                                                  firstReady ||
                                                  secondReady)
                                              ? CircularProgressIndicator()
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        height: 150,
                                                        width: 166,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: Image.network(
                                                            courseTaken[index]
                                                                ['url'],
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          courseTakenDetail[
                                                              index]['name'],
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 30),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                            courseTakenDetail[
                                                                    index]
                                                                ['description'],
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            textAlign:
                                                                TextAlign.left),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                        );
                                      }),
                                )),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 5, 0, 0),
                      child: Text(
                        "More courses to learn",
                        style: TextStyle(color: Colors.grey, fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 5),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                5, 15, 5, 20),
                            child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.5,
                                  mainAxisSpacing: 20,
                                  crossAxisSpacing: 5.0,
                                ),
                                itemCount: remainingCourse.length,
                                itemBuilder: (BuildContext cts, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CourseDetail(
                                                    courseName: basename(
                                                        remainingCourseDetail[
                                                            index]['name']),
                                                    mykad: widget.mykad,
                                                    coursePath:
                                                        remainingCourse[index]
                                                            ['path'],
                                                  )));
                                    },
                                    child: (remainingCourseDetail.isEmpty ||
                                            remainingCourse.isEmpty ||
                                            firstReady ||
                                            secondReady)
                                        ? CircularProgressIndicator()
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 150,
                                                  width: 166,
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: Image.network(
                                                      remainingCourse[index]
                                                          ['url'],
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    remainingCourseDetail[index]
                                                        ['name'],
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 30),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                      remainingCourseDetail[
                                                          index]['description'],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      textAlign:
                                                          TextAlign.left),
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
          )),
          ProfilePage(mykad: widget.mykad)
        ][currentPageIndex]);
  }
}
