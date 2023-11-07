import 'package:edtech/admin/createChapter.dart';
import 'package:edtech/database/adminDatabase.dart';
import 'package:flutter/material.dart';

class UploadResourcePage extends StatefulWidget {
  const UploadResourcePage({super.key});

  @override
  State<UploadResourcePage> createState() => _UploadResourcePageState();
}

class _UploadResourcePageState extends State<UploadResourcePage> {
  final _formKey = GlobalKey<FormState>();

  AdminDatabase admin = AdminDatabase();

  String name = '';
  String desc = '';
  String fileName = '';
  int chapter = 0;
  int month = 0;
  int point = 0;
  int video = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    decoration: const BoxDecoration(color: Colors.blue),
                    child: const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 100, 0, 0),
                      child: Text(
                        "Create Course",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter the course name',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4768FF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.menu_book,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter the course name!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        reverse: true,
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Enter the course description',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFF4768FF),
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(
                              Icons.edit,
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter the course description!";
                            } else {
                              return null;
                            }
                          },
                          maxLines: 2,
                          onChanged: (value) {
                            setState(() {
                              desc = value;
                            });
                          },
                        ),
                      )),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter number of chapter',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4768FF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.menu_book,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter number of chapter!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          chapter = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter number of months',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4768FF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.event,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter number of months!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          month = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter amount of points needed',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4768FF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.star,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter amount of points needed!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          point = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Enter the number of videos',
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF4768FF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        prefixIcon: Icon(
                          Icons.videocam,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter the number of videos!";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        setState(() {
                          video = int.parse(value);
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
                    child: Row(
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                fixedSize: const Size(150, 30)),
                            onPressed: () async {
                              String data = await admin.uploadCourseLogo(name);
                              setState(() {
                                fileName = data;
                              });
                            },
                            child: const Text(
                              "Upload logo",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            )),
                        SizedBox(width: 20),
                        Text(
                          fileName,
                          style:
                              const TextStyle(color: Colors.blue, fontSize: 15),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          fixedSize: const Size(300, 50)),
                      onPressed: () async {
                        await admin.createCourse(
                            name, desc, chapter, month, point, video);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateChapterPage(
                                    chapter: chapter, name: name, index: 1,)));
                      },
                      child: const Text(
                        "Create course",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ))
                ]))));
  }
}
