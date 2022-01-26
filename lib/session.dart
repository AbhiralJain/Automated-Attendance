import 'dart:async';

import 'package:attendance/config.dart';
import 'package:flutter/material.dart';

class Session extends StatefulWidget {
  final List slist;
  const Session({Key? key, required this.slist}) : super(key: key);

  @override
  _SessionState createState() => _SessionState();
}

class _SessionState extends State<Session> {
  late List slist;
  int index = 0;
  List<bool> adata = [];
  String pa = "";
  double _op = 1;
  Color b = Config.backgroundColor;
  Color f = Config.backgroundColor;
  @override
  void initState() {
    super.initState();
    slist = widget.slist;
    setState(() {
      pa = slist[index];
      f = Config.textcolor;
    });
  }

  notedown(bool value) {
    adata.add(value);
    setState(() {
      _op = 0;
      if (value) {
        pa = "Present";
        b = Colors.green.shade200;
        f = Colors.green.shade900;
      } else {
        pa = "Absent";
        b = Colors.red.shade200;
        f = Colors.red.shade900;
      }
    });
    Timer(const Duration(milliseconds: 500), () {
      if (index < slist.length - 1) {
        setState(() {
          index++;
          pa = slist[index];
          b = Config.backgroundColor;
          _op = 1;
          f = Config.textcolor;
        });
      } else {
        Navigator.pop(context, adata);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: b,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  pa,
                  style: TextStyle(
                    color: f,
                    fontSize: 50,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _op,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  color: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onPressed: () {
                    notedown(true);
                  },
                  child: Text(
                    'Present',
                    style: TextStyle(
                      color: Config.backgroundColor,
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _op,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: MaterialButton(
                  elevation: 0,
                  padding: const EdgeInsets.all(15),
                  color: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  onPressed: () {
                    notedown(false);
                  },
                  child: Text(
                    'Absent',
                    style: TextStyle(
                      color: Config.backgroundColor,
                      fontFamily: 'Montserrat',
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
