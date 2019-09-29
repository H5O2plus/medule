import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

//TODO: create a class "startwatch", similar to stopwatch but counts down

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medule',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Medule - School Schedule Tracker'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  /*
  This widget is the home page of your application. It is stateful, meaning that it has a State object (defined below) that contains fields that affect how it looks.
  This class is the configuration for the state. It holds the values (in this case the title) provided by the parent (in this case the App widget) and used by the build method of the State. Fields in a Widget subclass are always marked "final".
  */
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Stopwatch stopwatch = new Stopwatch();
  int _counter = 0;
  DateTime globalStartTime = DateTime(0);

  final Duration halfDay = new Duration(hours: 12);

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has changed in this State, which causes it to rerun the build method below so that the display can reflect the updated values. If we changed _counter without calling setState(), then the build method would not be called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _calibrateGlobalStartTime() {
    DateTime dateTimeOnCalibrate = new DateTime.now();

    if (dateTimeOnCalibrate.difference(globalStartTime) < halfDay) {
      _warnCalibrateTooSoon(dateTimeOnCalibrate);
    } else {
      _updateGlobalStartTime(dateTimeOnCalibrate);
    }
  }

  void _warnCalibrateTooSoon(DateTime dateTimeOnCalibrate) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("First bell was calibrated less than 12 hours ago!"),
          content: new Text("Are you sure you want to recalibrate?"),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Yes"),
              onPressed: () {
                _updateGlobalStartTime(dateTimeOnCalibrate);
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateGlobalStartTime(DateTime dateTimeOnCalibrate) {
    setState(() {
      //question: wait does this break? (pass by ref)
      //answer: No, I think
      this.globalStartTime = dateTimeOnCalibrate;
    });
  }

  @override
  Widget build(BuildContext context) {
    stopwatch.start();
    /*
    This method is rerun every time setState is called, for instance as done by the _incrementCounter method above.
    The Flutter framework has been optimized to make rerunning build methods fast, so that you can just rebuild anything that needs updating rather than having to individually change instances of widgets.
    */
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it in the middle of the parent.
        child: Column(
          /*
          Column is also layout widget. It takes a list of children and arranges them vertically. By default, it sizes itself to fit its children horizontally, and tries to be as tall as its parent.
          Invoke "debug painting" (press "p" in the console, choose the "Toggle Debug Paint" action from the Flutter Inspector in Android Studio, or the "Toggle Debug Paint" command in Visual Studio Code) to see the wireframe for each widget.
          Column has various properties to control how it sizes itself and how it positions its children. Here we use mainAxisAlignment to center the children vertically; the main axis here is the vertical axis because Columns are vertical (the cross axis would be horizontal).
          */
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            Text(
              globalStartTime.toString(),
            ),
            TimerText(stopwatch: stopwatch),
          ],
        ),
      ),
      floatingActionButton: RaisedButton(
        onPressed: _calibrateGlobalStartTime,
        //tooltip: 'Increment',
        child: Icon(Icons.compare_arrows),
      ),
    );
  }
}

// http://bizz84.github.io/2018/03/18/How-Fast-Is-Flutter.html

class TimerText extends StatefulWidget {
  TimerText({this.stopwatch});
  final Stopwatch stopwatch;

  TimerTextState createState() => new TimerTextState(stopwatch: stopwatch);
}

class TimerTextState extends State<TimerText> {
  Timer timer;
  final Stopwatch stopwatch;

  TimerTextState({this.stopwatch}) {
    timer = new Timer.periodic(new Duration(milliseconds: 30), callback);
  }

  void callback(Timer timer) {
    if (stopwatch.isRunning) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle timerTextStyle =
        const TextStyle(fontSize: 60.0, fontFamily: "Open Sans");
    String formattedTime = (stopwatch.elapsedMilliseconds ~/ 10).toString();
    return new Text(formattedTime, style: timerTextStyle);
  }
}