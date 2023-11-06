import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/quiz.dart';
import 'package:flutter/material.dart';

class CourseChapter extends StatefulWidget {
  final String mykad;
  final String courseName;
  final String coursePath;
  final int progress;
  const CourseChapter({
    super.key,
    required this.mykad,
    required this.courseName,
    required this.coursePath,
    required this.progress,
  });

  @override
  State<CourseChapter> createState() => _CourseChapterState();
}

class _CourseChapterState extends State<CourseChapter> {
  UserDatabase user = UserDatabase();

  String chapter = 'Chapter 1';
  bool finishChapter = false;
  int last = 0;
  int click = 0;

  List<String> dummyChap = [];
  List<String> chapters = [];
  List<List<String>> notes = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      chapter = 'Chapter ${widget.progress.toString()}';
    });
    getAllChapter();
  }

  void getCourseContent(data, courseChap) async {
    setState(() {
      for (int i = 0; i < courseChap.length; i++) {
        final splitNote = data[courseChap[i]].split('/ ');
        notes.add(splitNote);
        courseChap[i] = courseChap[i].split('_')[1].toUpperCase();
      }
    });
  }

  void getAllChapter() async {
    final data = await user.getCourseContent(widget.courseName.toLowerCase());
    data.keys.forEach((element) {
      setState(() {
        if (element.contains(chapter.replaceAll(" ", "").toLowerCase())) {
          dummyChap.add(element);
        }
        for (int i = 0; i < dummyChap.length; i++) {
          for (int j = 0; j < dummyChap.length; j++) {
            if (dummyChap[j].split('_')[2] == (i + 1).toString()) {
              chapters.add(dummyChap[j]);
              dummyChap[j] = "Empty_Empty_Empty";
              break;
            }
          }
        }
        last = data['chapter'];
      });
    });
    getCourseContent(data, chapters);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 125,
              decoration: const BoxDecoration(color: Colors.blue),
              child: Padding(
                padding: EdgeInsets.fromLTRB(5, 55, 0, 0),
                child: Text('${widget.courseName}-${chapter}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            for (int i = 0; i < notes.length; i++) ...[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    chapters[i],
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              for (int j = 0; j < notes[i].length; j = j + 2) ...[
                if (notes[i].length > 1) ...[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(notes[i][j],
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 25,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        notes[i][j + 1],
                        style: TextStyle(
                            color: Colors.amber,
                            fontSize: 15,
                            fontWeight: FontWeight.normal),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  )
                ] else
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(notes[i][j],
                          style: TextStyle(
                              color: Colors.amber,
                              fontSize: 15,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.justify),
                    ),
                  ),
              ],
            ],
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          finishChapter = true;
                          click++;
                        });
                        if (click + 1 == 3 && widget.progress == last) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      index: 0,
                                      total: 0,
                                      courseName: widget.courseName,
                                      coursePath: widget.coursePath,
                                      mykad: widget.mykad)));
                        } else if (click + 1 == 3) {
                          await user.changeChapterProgress(
                              widget.mykad,
                              widget.courseName.toLowerCase(),
                              widget.progress + 1);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CourseChapter(
                                        mykad: widget.mykad,
                                        courseName: widget.courseName,
                                        progress: widget.progress + 1,
                                        coursePath: widget.coursePath,
                                      )));
                        }
                      },
                      child: finishChapter
                          ? widget.progress != last
                              ? const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Next Chapter'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 24.0,
                                    ),
                                  ],
                                )
                              : const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Start the quiz'),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_right,
                                      size: 24.0,
                                    ),
                                  ],
                                )
                          : Text("Mark as complete"))
                ],
              ),
            ),
            SizedBox(height: 20),
          ],
        )));
  }
}
