import 'package:edtech/database/userDatabase.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class EduPointPage extends StatefulWidget {
  final String mykad;
  const EduPointPage({super.key, required this.mykad});

  @override
  State<EduPointPage> createState() => _EduPointPageState();
}

class _EduPointPageState extends State<EduPointPage> {
  String eduPoint = '';
  bool isReady = true;

  Map<String, dynamic> userDetail = {};
  List<Map> badge = [];
  List<Map> files = [];

  UserDatabase user = UserDatabase();

  @override
  void initState() {
    super.initState();
    getUserDetail();
  }

  void getUserDetail() async {
    final detail = await user.getUserDetail(widget.mykad);
    setState(() {
      userDetail = detail;
      eduPoint = userDetail['edu_point'].toString();
    });
    getBagdeFile(detail);
  }

  void getBagdeFile(detail) async {
    final file = await user.getAllCourseImage();
    setState(() {
      files = file;
      List<String> badgeMap = detail['course_finish'].split(', ');
      for (int i = 0; i < badgeMap.length; i++) {
        for (int j = 0; j < files.length; j++) {
          if (basename(files[j]['path']) == badgeMap[i]) {
            badge.add({
              'url': files[j]['url'].toString(),
              'path': basename(files[j]['path'])
            });
            files.removeAt(j);
            break;
          }
        }
      }
      isReady = false;
    });
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
              height: 150,
              decoration: const BoxDecoration(color: Colors.blue),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8, 70, 0, 0),
                child: Text(
                  "Your Edu Point",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              )),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
            child: Text("Now you have",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(eduPoint,
                  style: const TextStyle(
                      color: Colors.yellow,
                      fontSize: 100,
                      fontWeight: FontWeight.bold)),
              const Icon(Icons.star_border, color: Colors.yellow, size: 100)
            ],
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
            child: Text("Earned badge",
                style: TextStyle(
                    color: Colors.yellow,
                    fontSize: 30,
                    fontWeight: FontWeight.bold)),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                height: (badge.length / 2).ceil() * 200,
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 10.0,
                        ),
                        itemCount: badge.length,
                        itemBuilder: (BuildContext cts, index) {
                          return isReady
                              ? CircularProgressIndicator()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 150,
                                      width: 166,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          badge[index]['url'],
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                        }),
                  ),
                )),
          )
        ],
      )),
    );
  }
}
