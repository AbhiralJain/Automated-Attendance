import 'package:hive/hive.dart';
part 'hivedb.g.dart';

@HiveType(typeId: 1, adapterName: "ClassesTable")
class ClassDB {
  @HiveField(0)
  String? oname;

  @HiveField(1)
  String? cname;

  @HiveField(2)
  String? sname;

  @HiveField(3)
  String? epath;

  @HiveField(4)
  int? count;

  @HiveField(5)
  List<String>? students;
}
