import 'package:contest_calendar/services/contest.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void setUp() async {
    List<Contest>contests = await contest.getData();
    Navigator.pushReplacementNamed(context,'/home',arguments:{
      'contests':contests,
    });
  }

  @override
  void initState() {
    super.initState();
    setUp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: SpinKitCubeGrid(
          color:Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
