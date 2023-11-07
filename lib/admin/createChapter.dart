import 'package:edtech/admin/adminHome.dart';
import 'package:edtech/database/adminDatabase.dart';
import 'package:flutter/material.dart';

class CreateChapterPage extends StatefulWidget {
  final int chapter;
  final int index;
  final String name;
  const CreateChapterPage(
      {super.key,
      required this.chapter,
      required this.name,
      required this.index});

  @override
  State<CreateChapterPage> createState() => _CreateChapterPageState();
}

class _CreateChapterPageState extends State<CreateChapterPage> {
  AdminDatabase admin = AdminDatabase();

  String key = '';
  String topic = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 170,
          decoration: const BoxDecoration(color: Colors.blue),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 100, 0, 0),
            child: Text(
              "Create Chapter ${widget.index}",
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: Text(
            "Title",
            style: TextStyle(color: Colors.grey, fontSize: 30),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter title',
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
                return "Please enter the title!";
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                key = 'chapter${widget.index}_${value.toLowerCase()}_1';
              });
            },
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: Text(
            "Topic",
            style: TextStyle(color: Colors.grey, fontSize: 30),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter topic',
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
                return "Please enter the topic!";
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                topic = value;
              });
            },
          ),
        ),
        const Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: Text(
            "Description",
            style: TextStyle(color: Colors.grey, fontSize: 30),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(8, 20, 8, 0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: 'Enter description',
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
                return "Please enter the description!";
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() {
                description = value;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        widget.index == widget.chapter
            ? ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  setState(() {
                    topic = '$topic/ $description';
                  });
                  await admin.createChapter(
                      key, topic, widget.name.toLowerCase());
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text('The course is completely created!'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminHomePage())),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Finish",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                onPressed: () async {
                  setState(() {
                    topic = '$topic/ $description';
                  });
                  await admin.createChapter(
                      key, topic, widget.name.toLowerCase());
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateChapterPage(
                              chapter: widget.chapter,
                              name: widget.name,
                              index: widget.index + 1)));
                },
                child: const Text(
                  "Next Chapter",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ))
      ],
    )));
  }
}
