import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:shared_preferences/shared_preferences.dart';
    // show CalendarCarousel;

// void main() {
//   runApp(MaterialApp(home:CalendarExample()));
// }

class CalendarExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarExampleState();
  }
}

class _CalendarExampleState extends State<CalendarExample> {
  DateTime _currentDate = DateTime.now();
  EventList<Event> _markedDateMap = EventList<Event>(); // 追加

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() => _currentDate = date);
    if (events.length == 0) {
      Fluttertoast.showToast(msg: date.toString());
      addEvent(date);
    } else {
      Fluttertoast.showToast(msg: events[0].title);
    }  // 追加;
  }

  void addEvent(DateTime date) {
    _markedDateMap.add(date, createEvent(date));
  }  // 追加

  Event createEvent(DateTime date) {
    return Event(
        date: date,
        title: date.day.toString(),
        icon: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blue, width: 1.0)),
            child: Icon(
              Icons.calendar_today,
              color: Colors.blue,
            )
        )
    );
  } // 追加

  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      _textEditingController = new TextEditingController(text: prefs.getString("memo")); // <- こんな感じ
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text("Calendar Example"),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CalendarCarousel<Event>(
                  onDayPressed: onDayPressed,
                  weekendTextStyle: TextStyle(color: Colors.red),
                  thisMonthDayBorderColor: Colors.grey,
                  weekFormat: false,
                  height: 420.0,
                  selectedDateTime: _currentDate,
                  daysHaveCircularBorder: false,
                  customGridViewPhysics: NeverScrollableScrollPhysics(),
                  markedDatesMap: _markedDateMap,  // 追加
                  markedDateShowIcon: true,
                  markedDateIconMaxShown: 2,
                  todayTextStyle: TextStyle(
                    color: Colors.blue,
                  ),
                  markedDateIconBuilder: (event) {
                    return event.icon;
                  },
                  todayBorderColor: Colors.green,
                  markedDateMoreShowTotal: false),
                  TextField(
                    enabled: true,
                    maxLength: 20,
                    maxLengthEnforced: false,
                    style: TextStyle(color: Colors.black),
                    obscureText: false,
                    maxLines: 1,
                    onChanged: (text) { _changeMemo(text); },
                    controller: _textEditingController,
                  )
                ]
            )
          )
        ),
    );
  }

  String memo;
  List<String> _memoList = [];
  void _changeMemo(String text){
    setState(() {
      memo = text;
      storeMemo();
    });
  }

  void storeMemo() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString("memo", memo);
    if (!success) {
      debugPrint("Failed to store value");
    }
  }
}