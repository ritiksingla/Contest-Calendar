import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';

class Contest {
  String contestName;
  String contestStartTime;
  String contestDuration;
  String contestEndTime;
  String mURL;
  String site;

  Contest(
      {this.site,
      this.contestName,
      this.contestStartTime,
      this.contestEndTime,
      this.contestDuration,
      this.mURL});

  Future<List<Contest>> getData() async {
    try {
      //  making the request
      final String BASEURL = 'https://clist.by:443/api/v1/json/contest';
      final String KEY =
          '/?username=<USERNAME>&api_key=<API_KEY>';
      final String RESOURCES = "&resource__name__in=";
      final String SPACE = "%2C";
      final String PLATFORMS = 'codechef.com' +
          SPACE +
          'codeforces.com' +
          SPACE +
          'codingcompetitions.withgoogle.com' +
          SPACE +
          'leetcode.com' +
          SPACE +
          'kaggle.com' +
          SPACE +
          'atcoder.jp';
      final String FILTERS = "&order_by=start&start__gte=";
      DateTime now = DateTime.now();
      now = now.add(new Duration(hours:-5,minutes: -30));
      String formattedDate = now.year.toString()+"-" + now.month.toString()+"-" + now.day.toString() + "T" + now.hour.toString() +":"+ now.minute.toString()+":" + now.second.toString();
      // print(formattedDate);
      Response response = await get(
          BASEURL + KEY + RESOURCES + PLATFORMS + FILTERS + formattedDate);
      Map data = jsonDecode(response.body);
      //  getting properties from data
      List objects = data['objects'];
      List<Contest> contests = new List<Contest>();
      for (int i = 0; i < objects.length; ++i) {
        String eventName = objects[i]['event'];
        String startTime = objects[i]['start'];
        String endTime = objects[i]['end'];
        int duration = objects[i]['duration'];
        String href = objects[i]['href'];
        String site_ = objects[i]['resource']['name'];

        // Setting contest duration
        double time = duration / 3600;
        String contest_duration = time.toString() + ' Hours';

        //Date and Time formatter
        final formatter = DateFormat('dd-MM-yyyy hh:mm a');

        // Setting contest start time
        DateTime dateTime = DateTime.parse(startTime);
        dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
        // String contest_start_time = formatter.format(dateTime);
        String contest_start_time = dateTime.toString();

        // Setting contest end time
        dateTime = DateTime.parse(endTime);
        dateTime = dateTime.add(Duration(hours: 5, minutes: 30));
        String contest_end_time = dateTime.toString();
        // formatter.format(dateTime);
        contests.add(Contest(
            site: site_,
            contestName: eventName,
            contestDuration: contest_duration,
            contestEndTime: contest_end_time,
            contestStartTime: contest_start_time,
            mURL: href));
      }
      return contests;
    } catch (e) {
      print('Error in parsing the data: $e');
      contestName = 'Cannot get the contestName';
      contestDuration = 'Cannot get the contestDuration';
      contestEndTime = 'Cannot get the contestEndTime';
      contestStartTime = 'Cannot get the contestStartTime';
    }
  }
}

Contest contest = Contest();
