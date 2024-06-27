import 'package:new_project_bro/service/db_helper.dart';
import 'package:new_project_bro/service/db_service.dart';

class Bolimlar {
  static BolimlarService service = BolimlarService();
  static final Map<int, Bolimlar> obyektlar = {};

  int id = 0;
  String name = '';
  num tushummi_yoki_chiqimmi = 0;

  Bolimlar();

  Bolimlar.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
    tushummi_yoki_chiqimmi =
        num.tryParse(json['tushummi_yoki_chiqimmi'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tushummi_yoki_chiqimmi': tushummi_yoki_chiqimmi,
      };

  Future<int> insert() async {
    id = await service.insert(toJson());
    Bolimlar.obyektlar[id] = this;
    return id;
  }

  Future<void> delete() async {
    Bolimlar.obyektlar.remove(id);
    await service.delete(where: " id='$id'");
  }

  Future<void> update() async {
    Bolimlar.obyektlar[id] = this;
    await service.update(toJson(), where: " id='$id'");
  }
}

class BolimlarService extends CrudHelper {
  @override
  BolimlarService({super.prefix = ''}) : super("bolimlar");

  static String createTable = """
CREATE TABLE "bolimlar" (
  "id"  INTEGER NOT NULL DEFAULT 0,
  "name"  TEXT NOT NULL DEFAULT '',
  "tushummi_yoki_chiqimmi"  NUMERIC DEFAULT 0,
  PRIMARY KEY("id" AUTOINCREMENT)
);
  """;

  @override
  Future<Map> select({String? where}) async {
    where = where == null ? "" : " WHERE $where";
    Map<int, dynamic> map = {};
    await for (final rows
        in db.watch("SELECT * FROM $table $where", tables: [table])) {
      for (final element in rows) {
        map[element['id']] = element;
      }
      return map;
    }
    return map;
  }

  @override
  Future<Map> selectId(int id, {String? where}) async {
    Map row = await db.query("SELECT * FROM $table WHERE id = ?",
        params: [id], singleResult: true);
    return row;
  }

  @override
  Future<void> delete({String? where}) async {
    where = where == null ? "" : " WHERE $where";
    await db.query("DELETE FROM `$table` $where");
  }

  @override
  Future<void> deleteId(int id, {String? where}) async {
    if (where == null) {
      where = ' id=\'$id\'';
    } else {
      where = " id='$id' AND $where";
    }
    await delete(where: where);
  }

  @override
  Future<int> count({String? where}) async {
    where = where == null ? "" : " WHERE $where";
    Map row =
        await db.query("SELECT COUNT(*) FROM $table$where", singleResult: true);
    return int.parse(row['seq'].toString()) + 1;
  }

  @override
  Future<int> insert(Map map) async {
    map['id'] = (map['id'] == 0) ? null : map['id'];

    var insertId = await db.insert(map as Map<String, dynamic>, table);
    return insertId;
  }

  @override
  Future<int> newId() async {
    Map row = await db.query("SELECT * FROM sqlite_sequence WHERE name = ?",
        params: [table], singleResult: true);
    return int.parse(row['seq'].toString()) + 1;
  }

  @override
  Future<int> replace(Map map) async {
    map['id'] = (map['id'] == 0) ? null : map['id'];

    var cols = '';
    var vals = '';

    var vergul = '';

    map.forEach(
      (col, val) {
        val = val.toString().replaceAll("\\", "/").replaceAll("'", "`");
        col = col;
        cols += "$vergul `$col`";
        vals += "$vergul '$val'";
        if (vergul == "") {
          vergul = ',';
        }
      },
    );
    var sql = "REPLACE INTO $table ($cols) VALUES ($vals)";
    await db.query(sql);
    return 0;
  }

  @override
  Future<void> update(Map map, {String? where}) async {
    where = where == null ? "" : " WHERE $where";
    String updateClause = "";
    final List params = [];
    final values = map.keys; //.where((element) => !keys.contains(element));
    for (String value in values) {
      if (updateClause.isNotEmpty) updateClause += ", ";
      updateClause += "$value=?";
      params.add(map[value]);
    }
    final String sql = "UPDATE $table SET $updateClause$where";
    await db.execute(sql, tables: [table], params: params);
  }
}
