import 'package:new_project_bro/service/db_helper.dart';
import 'package:new_project_bro/service/db_service.dart';

class KantaktBolim {
  static KantaktBolimService service = KantaktBolimService();
  static final Map<int, KantaktBolim> obyektlar = {};

  int id = 0;
  String name = '';
  num tartib_raqam = 0;
  KantaktBolim();
  KantaktBolim.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
    tartib_raqam = num.tryParse(json['tartib_raqam'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tartib_raqam': tartib_raqam,
      };

  Future<int> insert() async {
    id = await service.insert(toJson());
    KantaktBolim.obyektlar[id] = this;
    return id;
  }

  Future<void> delete() async {
    KantaktBolim.obyektlar.remove(id);
    await service.delete(where: " id='$id'");
  }

  Future<void> update() async {
    KantaktBolim.obyektlar[id] = this;
    await service.update(toJson(), where: " id='$id'");
  }
}

class KantaktBolimService extends CrudHelper {
  @override
  KantaktBolimService({super.prefix = ''}) : super("kantaktbolim");

  static String createTable = """
CREATE TABLE "kantaktbolim" (
  "id"  INTEGER NOT NULL DEFAULT 0,
  "name"  TEXT NOT NULL DEFAULT '',
  "tartib_raqam"  NUMERIC DEFAULT 0,
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
    final values = map.keys;
    for (String value in values) {
      if (updateClause.isNotEmpty) updateClause += ", ";
      updateClause += "$value=?";
      params.add(map[value]);
    }
    final String sql = "UPDATE $table SET $updateClause$where";
    await db.execute(sql, tables: [table], params: params);
  }
}
