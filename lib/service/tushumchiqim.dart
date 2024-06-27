import 'package:new_project_bro/service/db_helper.dart';
import 'package:new_project_bro/service/db_service.dart';

class TushumChiqim {
  static TushumChiqimService service = TushumChiqimService();
  static final Map<int, TushumChiqim> obyektlar = {};

  int id = 0;
  String name = '';
  String vaqti = '';
  num price = 0;
  num tushummi_yoki_chiqimmi = 0;
  int idKarta = 0;
  int idKantakt = 0;
  int idBolim = 0;

  TushumChiqim();

  TushumChiqim.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    name = json['name'].toString();
    vaqti = json['name'].toString();
    price = num.tryParse(json['price'].toString()) ?? 0;
    tushummi_yoki_chiqimmi =
        num.tryParse(json['tushummi_yoki_chiqimmi'].toString()) ?? 0;
    idKarta = int.tryParse(json['idKarta'].toString()) ?? 0;
    idKantakt = int.tryParse(json['idKantakt'].toString()) ?? 0;
    idBolim = int.tryParse(json['idBolim'].toString()) ?? 0;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'vaqti': vaqti,
        'price': price,
        'tushummi_yoki_chiqimmi': tushummi_yoki_chiqimmi,
        'idKarta': idKarta,
        'idKantakt': idKantakt,
        'idBolim': idBolim,
      };

  Future<int> insert() async {
    id = await service.insert(toJson());
    TushumChiqim.obyektlar[id] = this;
    return id;
  }

  Future<void> delete() async {
    TushumChiqim.obyektlar.remove(id);
    await service.delete(where: " id='$id'");
  }

  Future<void> update() async {
    TushumChiqim.obyektlar[id] = this;
    await service.update(toJson(), where: " id='$id'");
  }
}

class TushumChiqimService extends CrudHelper {
  @override
  TushumChiqimService({super.prefix = ''}) : super("tushummi_chiqimmi");

  static String createTable = """
CREATE TABLE "tushummi_chiqimmi" (
  "id"  INTEGER NOT NULL DEFAULT 0,
  "name"  TEXT NOT NULL DEFAULT '',
  "vaqti"  TEXT NOT NULL DEFAULT '',
  "price"  NUMERIC DEFAULT 0,
  "tushummi_yoki_chiqimmi"  INTEGER NOT NULL DEFAULT 0,
  "idKarta"  INTEGER NOT NULL DEFAULT 0,
  "idKantakt"  INTEGER NOT NULL DEFAULT 0,
  "idBolim"  INTEGER NOT NULL DEFAULT 0,
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
        params: [table],
        //fromMap: (map) => {},
        singleResult: true);
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
