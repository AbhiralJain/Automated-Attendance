import 'dart:io';
import 'package:attendance/config.dart';
import 'package:attendance/dbclass/hivedb.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:desktop_drop/desktop_drop.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({Key? key}) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final FocusNode _of = FocusNode();
  final FocusNode _tf = FocusNode();
  final FocusNode _cf = FocusNode();
  final FocusNode _sf = FocusNode();
  final FocusNode _kf = FocusNode();
  final TextEditingController _oc = TextEditingController();
  final TextEditingController _tc = TextEditingController();
  final TextEditingController _cc = TextEditingController();
  final TextEditingController _sc = TextEditingController();
  final TextEditingController _kc = TextEditingController();
  final ScrollController _lsc = ScrollController();
  bool isListed = false;
  List<String> studentslist = [];
  Future<bool> requestpermission(Permission permission) async {
    if (Platform.isAndroid) {
      if (await permission.isGranted) {
        return true;
      } else {
        var result = await permission.request();
        if (result == PermissionStatus.granted) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      return true;
    }
  }

  textf(focs, cont, hint) {
    return Container(
      height: 50,
      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
      decoration: BoxDecoration(
        color: Config.tilesColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: TextField(
        textCapitalization: TextCapitalization.words,
        textInputAction: TextInputAction.go,
        focusNode: focs,
        onEditingComplete: () {
          if (focs != _kf) {
            focs.nextFocus();
          } else {
            setState(() {
              if (_kc.text != '') {
                studentslist.add(_kc.text);
                studentslist.sort();
                _kc.text = '';
                _kf.requestFocus();
                if (isListed) {
                  _lsc.jumpTo(_lsc.position.maxScrollExtent + 20);
                }
                isListed = true;
              }
            });
          }
        },
        style: TextStyle(
          color: Config.textcolor,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        controller: cont,
        decoration: InputDecoration(
          counterText: "",
          hintText: hint,
          border: InputBorder.none,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  students(index) {
    return Text(
      "${index + 1}. ${studentslist[index]}",
      style: TextStyle(
        color: Config.textcolor,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    );
  }

  Future<String> createxcel(oname, tname, cname, sname, klist) async {
    bool perm = await requestpermission(Permission.storage);
    if (perm) {
      Excel excel = Excel.createExcel();
      excel.merge(
        "Sheet1",
        CellIndex.indexByString("A1"),
        CellIndex.indexByString("E1"),
      );
      excel.updateCell(
        "Sheet1",
        CellIndex.indexByString("A1"),
        "$oname",
        cellStyle: CellStyle(verticalAlign: VerticalAlign.Center),
      );
      excel.merge(
        "Sheet1",
        CellIndex.indexByString("A3"),
        CellIndex.indexByString("C3"),
      );
      excel.updateCell(
        "Sheet1",
        CellIndex.indexByString("A3"),
        "Name: $tname",
        cellStyle: CellStyle(verticalAlign: VerticalAlign.Center),
      );
      excel.merge(
        "Sheet1",
        CellIndex.indexByString("A4"),
        CellIndex.indexByString("D4"),
      );
      excel.updateCell(
        "Sheet1",
        CellIndex.indexByString("A4"),
        "Class: $cname - $sname",
        cellStyle: CellStyle(verticalAlign: VerticalAlign.Center),
      );
      excel.merge(
        "Sheet1",
        CellIndex.indexByString("A7"),
        CellIndex.indexByString("B7"),
      );
      excel.updateCell(
        "Sheet1",
        CellIndex.indexByString("A7"),
        "Student Name:",
        cellStyle: CellStyle(verticalAlign: VerticalAlign.Center),
      );
      for (int i = 0; i < klist.length; i++) {
        excel.merge(
          "Sheet1",
          CellIndex.indexByString("A${i + 8}"),
          CellIndex.indexByString("B${i + 8}"),
        );
        excel.updateCell(
          "Sheet1",
          CellIndex.indexByString("A${i + 8}"),
          klist[i],
          cellStyle: CellStyle(verticalAlign: VerticalAlign.Center),
        );
      }
      List<int>? fileBytes = excel.encode();
      List<int> fbytes = fileBytes!;
      Directory dir = await getApplicationDocumentsDirectory();
      String filename = "${oname.trim().split(' ').map((l) => l[0]).join()}${cname[0]}${sname[0]}.xlsx";
      File ffile = File("${dir.path}/Attendance_Files/$filename")
        ..createSync(recursive: true)
        ..writeAsBytesSync(fbytes);
      return ffile.path;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Config.textcolor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Create a class",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Config.textcolor,
                        fontFamily: "Montserrat",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: textf(_tf, _tc, "Enter your name"),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: textf(_of, _oc, "Enter organization name"),
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
                      child: textf(_cf, _cc, "Class"),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 0, 10),
                      child: textf(_sf, _sc, "Section"),
                    ),
                  ),
                ],
              ),
              textf(_kf, _kc, "Enter name of students"),
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Student's names appear below",
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                  ),
                ),
              ),
              DropTarget(
                onDragDone: (f) async {
                  File tfile = File(f.files[0].path);
                  final fcontent = await tfile.readAsString();
                  studentslist = [];
                  String name = '';
                  for (int i = 0; i < fcontent.length; i++) {
                    if (fcontent[i] == '\n') {
                      name = name.replaceAll(RegExp(r'[0-9]'), '').replaceAll(RegExp(r'[^\w\s]+'), '').trim();
                      studentslist.add(name);
                      name = '';
                    } else {
                      name = name + fcontent[i];
                    }
                  }
                  setState(() {
                    studentslist.sort();
                    isListed = true;
                  });
                },
                child: Expanded(
                  child: isListed
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: ListView.builder(
                            controller: _lsc,
                            itemCount: studentslist.length,
                            itemBuilder: (BuildContext context, int index) => students(index),
                          ),
                        )
                      : const Center(
                          child: Text(
                            "Or you can drag a text file containing name of students over here",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: 'Montserrat',
                              fontSize: 20,
                            ),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: (MediaQuery.of(context).viewInsets.bottom == 0)
          ? FloatingActionButton(
              backgroundColor: Config.textcolor,
              foregroundColor: Config.backgroundColor,
              onPressed: () async {
                if (_cc.text == '' || _sc.text == '' || _oc.text == '' || _tc.text == '') {
                  Alert(
                    style: Config.alertConfig,
                    context: context,
                    title: 'Please fill all the mentioned fields.',
                    buttons: [
                      DialogButton(
                        highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                        splashColor: const Color.fromRGBO(0, 0, 0, 0),
                        radius: const BorderRadius.all(Radius.circular(20)),
                        color: Config.textcolor,
                        child: Text(
                          "OK",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Config.backgroundColor,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        width: 120,
                      )
                    ],
                  ).show();
                } else {
                  String epath = await createxcel(
                    _oc.text,
                    _tc.text,
                    _cc.text,
                    _sc.text,
                    studentslist,
                  );
                  final classdata = ClassDB()
                    ..oname = _oc.text
                    ..cname = _cc.text
                    ..epath = epath
                    ..sname = _sc.text
                    ..count = 0
                    ..students = studentslist;
                  Navigator.pop(context, classdata);
                }
              },
              tooltip: 'Create Class',
              child: const Icon(Icons.done_rounded),
            )
          : null,
    );
  }
}
