import 'dart:io';
import 'package:attendance/session.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share_plus/share_plus.dart';
import 'config.dart';
import 'createclass.dart';
import 'dbclass/hivedb.dart';
import 'package:intl/intl.dart';

class Classes extends StatefulWidget {
  const Classes({Key? key}) : super(key: key);

  @override
  _ClassesState createState() => _ClassesState();
}

class _ClassesState extends State<Classes> {
  int rows = 2;
  double ratio = 1;
  int cindex = -1;
  List clist = [];
  classW(index) {
    return GestureDetector(
      onTap: () {
        Alert(
          style: Config.alertConfig,
          context: context,
          title: '${clist[index].cname} - ${clist[index].sname}',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DialogButton(
                highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                radius: const BorderRadius.all(Radius.circular(20)),
                color: Config.textcolor,
                child: Text(
                  "Take Attendance",
                  style: TextStyle(
                    color: Config.backgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onPressed: () async {
                  List<bool> adata = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Session(
                        slist: clist[index].students,
                      ),
                    ),
                  );

                  var file = clist[index].epath;
                  var bytes = File(file).readAsBytesSync();
                  var excel = Excel.decodeBytes(bytes);
                  Box<ClassDB> box = await Hive.openBox<ClassDB>('classes');
                  ClassDB idata = box.values.elementAt(index);
                  int acount = idata.count! + 1;
                  excel.updateCell(
                    "Sheet1",
                    CellIndex.indexByColumnRow(
                      columnIndex: (2 + clist[index].count).toInt(),
                      rowIndex: (5),
                    ),
                    acount,
                    cellStyle: CellStyle(
                      horizontalAlign: HorizontalAlign.Center,
                      verticalAlign: VerticalAlign.Center,
                    ),
                  );
                  DateTime now = DateTime.now();
                  String ctime = DateFormat('dd/MM/yy - hh:mm').format(now);
                  excel.updateCell(
                    "Sheet1",
                    CellIndex.indexByColumnRow(columnIndex: (2 + clist[index].count).toInt(), rowIndex: (6)),
                    ctime,
                    cellStyle: CellStyle(horizontalAlign: HorizontalAlign.Center, verticalAlign: VerticalAlign.Center),
                  );
                  for (int i = 0; i < adata.length; i++) {
                    if (adata[i]) {
                      excel.updateCell(
                        "Sheet1",
                        CellIndex.indexByColumnRow(
                          columnIndex: (2 + clist[index].count).toInt(),
                          rowIndex: (i + 7),
                        ),
                        "P",
                        cellStyle: CellStyle(
                            backgroundColorHex: 'FFA5D6A7',
                            horizontalAlign: HorizontalAlign.Center,
                            verticalAlign: VerticalAlign.Center),
                      );
                    } else {
                      excel.updateCell(
                        "Sheet1",
                        CellIndex.indexByColumnRow(
                          columnIndex: (2 + clist[index].count).toInt(),
                          rowIndex: (i + 7),
                        ),
                        "A",
                        cellStyle: CellStyle(
                            backgroundColorHex: 'FFEF9A9A',
                            horizontalAlign: HorizontalAlign.Center,
                            verticalAlign: VerticalAlign.Center),
                      );
                    }
                  }

                  List<int>? fileBytes = excel.encode();
                  List<int> fbytes = fileBytes!;
                  File ffile = File(clist[index].epath);
                  await ffile.delete(recursive: true);
                  await ffile.create(recursive: true);
                  await ffile.writeAsBytes(fbytes);
                  ClassDB udata = ClassDB()
                    ..cname = idata.cname
                    ..count = acount
                    ..epath = idata.epath
                    ..oname = idata.oname
                    ..sname = idata.sname
                    ..students = idata.students;
                  box.putAt(index, udata);
                  setState(() {
                    clist = box.values.toList();
                  });
                  Navigator.pop(context);
                  Alert(
                    context: context,
                    style: Config.alertConfig,
                    title: 'Attendance taken successfully',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: Config.textcolor,
                          child: Text(
                            "View Excel Sheet",
                            style: TextStyle(
                              color: Config.backgroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onPressed: () async {
                            await OpenFile.open(clist[index].epath);
                          },
                          width: 120,
                        ),
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: Config.textcolor,
                          child: Text(
                            "Export File",
                            style: TextStyle(
                              color: Config.backgroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onPressed: () async {
                            var cd = DateTime.now();
                            String fd = DateFormat('dd-MM-yy').format(cd);
                            String fc = "${clist[index].cname}-${clist[index].sname}";
                            if (!Platform.isAndroid) {
                              File exl = File(clist[index].epath);
                              Directory? dwn = await getDownloadsDirectory();
                              await exl.copy("${dwn!.path}/$fc-$fd.xlsx");
                              Navigator.pop(context);
                              Alert(
                                context: context,
                                style: Config.alertConfig,
                                title: "File saved to Downloads folder.",
                                buttons: [
                                  DialogButton(
                                    highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                                    splashColor: const Color.fromRGBO(0, 0, 0, 0),
                                    radius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                    color: Config.textcolor,
                                    child: Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Config.backgroundColor,
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    width: 120,
                                  ),
                                ],
                              ).show();
                            } else {
                              await Share.shareFiles([clist[index].epath], text: '$fc-$fd.xlsx');
                            }
                          },
                          width: 120,
                        ),
                        DialogButton(
                          highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                          splashColor: const Color.fromRGBO(0, 0, 0, 0),
                          radius: const BorderRadius.all(Radius.circular(20)),
                          color: Config.textcolor,
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Config.backgroundColor,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          width: 120,
                        ),
                      ],
                    ),
                    buttons: [],
                  ).show();
                },
                width: 120,
              ),
              DialogButton(
                highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                radius: const BorderRadius.all(Radius.circular(20)),
                color: Config.textcolor,
                child: Text(
                  "View Excel Sheet",
                  style: TextStyle(
                    color: Config.backgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onPressed: () async {
                  await OpenFile.open(clist[index].epath);
                },
                width: 120,
              ),
              DialogButton(
                highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                radius: const BorderRadius.all(Radius.circular(20)),
                color: Config.textcolor,
                child: Text(
                  "Delete Class",
                  style: TextStyle(
                    color: Config.backgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onPressed: () async {
                  Box<ClassDB> box = await Hive.openBox<ClassDB>('classes');
                  File ffile = File(clist[index].epath);
                  await ffile.delete(recursive: true);
                  box.deleteAt(index);
                  setState(() {
                    clist = box.values.toList();
                  });
                  Navigator.pop(context);
                },
                width: 120,
              ),
              DialogButton(
                highlightColor: const Color.fromRGBO(0, 0, 0, 0),
                splashColor: const Color.fromRGBO(0, 0, 0, 0),
                radius: const BorderRadius.all(Radius.circular(20)),
                color: Config.textcolor,
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Config.backgroundColor,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                width: 120,
              ),
            ],
          ),
          buttons: [],
        ).show();
      },
      child: MouseRegion(
        onEnter: (event) {
          setState(() {
            cindex = index;
          });
        },
        onExit: (event) {
          setState(() {
            cindex = -1;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(15),
          margin: cindex == index ? const EdgeInsets.all(5) : const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Config.tilesColor,
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${clist[index].cname} - ${clist[index].sname}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Config.textcolor,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${clist[index].oname}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Config.textcolor,
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                ),
              ),
              clist[index].count == 1
                  ? Text(
                      "Attendance taken\n${clist[index].count} time",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Config.textcolor,
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                      ),
                    )
                  : Text(
                      "Attendance taken\n${clist[index].count} times",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Config.textcolor,
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  openDatabase() async {
    Box<ClassDB> box = await Hive.openBox<ClassDB>('classes');
    setState(() {
      clist = box.values.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    openDatabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(MediaQuery.of(context).size.width);
    setState(() {
      if (MediaQuery.of(context).size.width < 250) {
        rows = 1;
        ratio = 2;
      } else {
        rows = MediaQuery.of(context).size.width ~/ 250;
        if (rows == 1) {
          ratio = 2;
        } else {
          ratio = 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Config.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "Please select the class",
                  style: TextStyle(
                    color: Config.textcolor,
                    fontFamily: 'Montserrat',
                    fontSize: 20,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  itemCount: clist.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: ratio,
                    crossAxisCount: rows,
                  ),
                  itemBuilder: (BuildContext context, int index) => classW(index),
                ),
              ),
              Container()
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Config.textcolor,
        foregroundColor: Config.backgroundColor,
        onPressed: () async {
          final classdata = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateClass(),
            ),
          );
          if (classdata != null) {
            Box<ClassDB> box = await Hive.openBox<ClassDB>('classes');
            box.add(classdata);
            setState(() {
              clist = box.values.toList();
            });
          }
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }
}
