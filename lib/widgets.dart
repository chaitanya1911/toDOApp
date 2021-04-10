import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String discription;
  TaskCardWidget({this.title, this.discription});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "UnNamed Task",
            style: TextStyle(
                color: Color(0xFF211551),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Text(
            discription ?? "Un defined discription",
            style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
          )
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;
  TodoWidget({this.text, @required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          children: [
            Container(
              height: 20,
              width: 20,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: isDone ? Colors.blue : Colors.black,
                  border: isDone
                      ? null
                      : Border.all(color: Colors.black, width: 1.5)),
              child: isDone
                  ? Image(
                      image: AssetImage("assets/images/check_icon.png"),
                    )
                  : null,
            ),
            Container(
              child: Text(
                "$isDone",
              ),
            ),
            Text(
              text ?? "Unnamed todowidget",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDone ? Colors.black : Colors.grey),
            ),
          ],
        ));
  }
}

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
