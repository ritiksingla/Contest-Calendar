import 'package:contest_calendar/services/contest.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};
  List<Contest> contests;
  final formatter = DateFormat('MMM dd, yyyy hh:mm a');
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    contests = data['contests'];
    return Scaffold(
      key: scaffoldState,
      backgroundColor: Colors.blue[700],
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        title: Text('Contests'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: contests.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(3),
            child: Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth:80,
                      minHeight: 80,
                      maxWidth: 80,
                      maxHeight: 120,
                    ),
                    child: Image.asset(
                        'assets/${contests[index].site}.png',
                    ),
                  ),
                  title: Text(
                    contests[index].contestName,
                  ),
                  subtitle: Text(
                    'Start: ' +
                        formatter.format(DateTime.parse(contests[index].contestStartTime)).toString() +
                        '\n' +
                        'End: ' +
                        formatter.format(DateTime.parse(contests[index].contestEndTime)).toString(),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      TextButton(
                        child: Icon(Icons.public),
                        onPressed: () {
                          _launchURL(contests[index].mURL);
                        },
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                        child: Icon(Icons.calendar_today_rounded),
                        onPressed: () {
                          final Event event = Event(
                            title: contests[index].contestName,
                            description: contests[index].mURL,
                            startDate: DateTime.parse(contests[index].contestStartTime),
                            endDate: DateTime.parse(contests[index].contestEndTime),
                            timeZone: 'Asia/Kolkata',
                          );
                          Add2Calendar.addEvent2Cal(event).then((success) {
                            scaffoldState.currentState.showSnackBar(
                                SnackBar(content: Text(success ? 'Success' : 'Error')));
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                    ])
              ],
            )),
          );
        },
      ),
    );
  }
}

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
