import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/result.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final int index;
  final int total;
  final String courseName;
  final String mykad;
  const QuizPage(
      {super.key,
      required this.index,
      required this.total,
      required this.courseName,
      required this.mykad});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  UserDatabase user = UserDatabase();

  int questionIndex = 0;
  int total = 0;

  List<String> question = [];
  List<String> answer = [];

  List<List<String>> option = [[], [], [], []];

  @override
  void initState() {
    super.initState();
    setState(() {
      questionIndex = widget.index;
      total = widget.total;
    });
    getQuizDetail();
  }

  void getQuizDetail() async {
    final detail = await user.getQuizDetail(widget.courseName.split('.')[0]);
    setState(() {
      question = detail['question'].split(', ');
      answer = detail['answer'].split(', ');
      final options = detail['option'].split(', ');
      for (int i = 0; i < options.length / 4; i++) {
        for (int j = i * 4; j < i * 4 + 4; j++) {
          option[i].add(options[j]);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(color: Colors.blue),
              child: const Padding(
                padding: EdgeInsets.fromLTRB(8, 70, 0, 0),
                child: Text(
                  "Quiz Time!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              )),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15.0, 10, 0, 0),
              child: Text(
                'Question ${questionIndex + 1}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            child: Center(
                child: question.length == 0
                    ? CircularProgressIndicator()
                    : Text(
                        question[questionIndex],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      )),
          ),
          SizedBox(height: 10),
          for (int i = 0; i < option[questionIndex].length; i++) ...[
            Container(
              child: Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Color(0xFF4768FF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.fromLTRB(100, 10, 100, 10)),
                    onPressed: () async {
                      if (questionIndex + 1 < question.length) {
                        if ((option[questionIndex][i] ==
                            answer[questionIndex])) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                      index: questionIndex + 1,
                                      total: total + 1,
                                      courseName: widget.courseName,
                                      mykad: widget.mykad)));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                        index: questionIndex + 1,
                                        total: total,
                                        courseName: widget.courseName,
                                        mykad: widget.mykad,
                                      )));
                      } else {
                        if ((option[questionIndex][i] ==
                            answer[questionIndex])) {
                          total++;
                          print("1");
                          if(total >= question.length.ceil()){
                            await user.finishCourse(widget.mykad, widget.courseName);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                      result: total,
                                      length: question.length,
                                      courseName: widget.courseName,
                                      mykad: widget.mykad)));
                        } else {
                          print("2");
                          if(total >= question.length.ceil()){
                            await user.finishCourse(widget.mykad, widget.courseName);
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        result: total,
                                        length: question.length,
                                        courseName: widget.courseName,
                                        mykad: widget.mykad,
                                      )));
                        }
                      }
                    },
                    child: Text(option[questionIndex][i],
                        style: TextStyle(color: Colors.white, fontSize: 20))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ]
        ],
      ),
    );
  }
}
