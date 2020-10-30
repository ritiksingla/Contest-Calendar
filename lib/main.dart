import 'package:flutter/material.dart';
import 'package:contest_calendar/pages/home.dart';
import 'package:contest_calendar/pages/loading.dart';

void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
    '/': (context) => Loading(),
    '/home': (context) => Home(),
  },
));