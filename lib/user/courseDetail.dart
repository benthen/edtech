import 'package:edtech/login/login.dart';
import 'package:edtech/user/home.dart';
import 'package:edtech/user/unlockedCourse.dart';
import 'package:flutter/material.dart';

class CourseDetail extends StatefulWidget {
  final String courseName;
  final String mykad;
  const CourseDetail({super.key, required this.courseName, required this.mykad});

  @override
  State<CourseDetail> createState() => _CourseDetailState();
}

class _CourseDetailState extends State<CourseDetail> {
  int currentPageIndex = 0;

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
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 125,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 55, 0, 0),
                    child: Text('${widget.courseName.split('.')[0]}',
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
                          child: Text(
                              "By taking Biology course, you are able to learn how to kill a frog and also sleep in the class because the lecture is too boring. You also will learn a lot of bio things that are useless to computer science students as they only know how to code only",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                        )),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 40),
                      Icon(Icons.edit),
                      Text("12 chapters", style: TextStyle(fontSize: 20)),
                      SizedBox(width: 30),
                      Icon(Icons.videocam),
                      Text("24 lecture videos", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Row(children: [
                    SizedBox(width: 40),
                    Icon(Icons.schedule),
                    Text("1-3 months", style: TextStyle(fontSize: 20)),
                    SizedBox(width: 35),
                    Icon(Icons.grade),
                    Text("2500 points", style: TextStyle(fontSize: 20))
                  ]),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context)=>UnlockedCoursePage(courseName: widget.courseName, mykad: widget.mykad)));},
                        child: Text(
                          "Unlock Now!",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            padding:
                                const EdgeInsets.fromLTRB(150, 10, 150, 10)),
                      ),
                    ],
                  )
                ]))
              ],
            ),
          ),
          MainPageUiWidget(mykad: widget.mykad),
          LoginPageWidget(),
        ][currentPageIndex]);
  }
}
