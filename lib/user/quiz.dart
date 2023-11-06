import 'package:edtech/database/userDatabase.dart';
import 'package:edtech/user/result.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final int index;
  final int total;
  final String courseName;
  final String coursePath;
  final String mykad;
  const QuizPage(
      {super.key,
      required this.index,
      required this.total,
      required this.courseName,
      required this.coursePath,
      required this.mykad});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  UserDatabase user = UserDatabase();

  int questionIndex = 0;
  int total = 0;
  String quizResult = '';

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
    final detail = await user.getQuizDetail(widget.courseName.toLowerCase());
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
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: Center(
                  child: question.length == 0
                      ? CircularProgressIndicator()
                      : Text(
                          question[questionIndex],
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w700),
                        )),
            ),
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
                        fixedSize: const Size(300, 50)),
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
                                      coursePath: widget.coursePath,
                                      mykad: widget.mykad)));
                        } else
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizPage(
                                        index: questionIndex + 1,
                                        total: total,
                                        courseName: widget.courseName,
                                        coursePath: widget.coursePath,
                                        mykad: widget.mykad,
                                      )));
                      } else {
                        if ((option[questionIndex][i] ==
                            answer[questionIndex])) {
                          total++;
                          if (total >= (question.length / 2).ceil()) {
                            await user.finishCourse(
                                widget.mykad, widget.coursePath);
                            setState(() {
                              quizResult = 'PASSED';
                            });
                            await user.awardPoint(widget.mykad);
                          } else
                            setState(() {
                              quizResult = 'FAILED';
                            });
                          await user.updateQuizResult(widget.mykad,
                              widget.courseName.toLowerCase(), quizResult);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        result: total,
                                        length: question.length,
                                        coursePath: widget.coursePath,
                                        courseName: widget.courseName,
                                        mykad: widget.mykad,
                                        quizResult: quizResult,
                                      )));
                        } else {
                          if (total >= (question.length / 2).ceil()) {
                            await user.finishCourse(
                                widget.mykad, widget.coursePath);
                            setState(() {
                              quizResult = 'PASSED';
                            });
                            await user.awardPoint(widget.mykad);
                          } else
                            setState(() {
                              quizResult = 'FAILED';
                            });
                          await user.updateQuizResult(widget.mykad,
                              widget.courseName.toLowerCase(), quizResult);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResultPage(
                                        result: total,
                                        length: question.length,
                                        coursePath: widget.coursePath,
                                        courseName: widget.courseName,
                                        mykad: widget.mykad,
                                        quizResult: quizResult,
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
