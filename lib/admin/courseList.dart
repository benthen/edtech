import 'package:edtech/database/adminDatabase.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  AdminDatabase admin = AdminDatabase();

  List<Map> courseDetail = [];
  List<Map> image = [];

  bool isReady = true;

  @override
  void initState() {
    super.initState();
    getAllCourseImage();
  }

  void getAllCourseImage() async {
    final data = await admin.getAllCourseImage();
    setState(() {
      image = data;
    });
    getCourseDetail(image);
  }

  void getCourseDetail(image) async {
    for (int i = 0; i < image.length; i++) {
      final detail = await admin
          .getAllCourseDetail(basename(image[i]['path'].split('.')[0]));
      setState(() {
        courseDetail.add(
            {"name": detail['name'], "description": detail['description']});
      });
    }
    setState(() {
      isReady = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Container(
        width: MediaQuery.of(context).size.width,
        height: 170,
        decoration: BoxDecoration(color: Colors.blue),
        child: const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10, 100, 0, 0),
          child: Text(
            "Course List",
            style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      isReady
          ? CircularProgressIndicator()
          : Container(
              height: 550,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: courseDetail.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(5.0, 0, 5, 10),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.purple, borderRadius: BorderRadius.circular(10)),
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(children: [
                            Container(
                              decoration: const BoxDecoration(boxShadow: [
                                BoxShadow(
                                  blurRadius: 10.0,
                                ),
                              ]),
                              height: 100,
                              width: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  image[index]['url'],
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  child: Text(
                                    "${courseDetail[index]['name']}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                      courseDetail[index]['description'],
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500, color: Colors.white),
                                      textAlign: TextAlign.left),
                                ),
                              ],
                            ),
                          ]),
                        ),
                      ),
                    );
                  })),
    ])));
  }
}
