abstract class CrudHelper {
  late final String prefix;
  late final String table;

  CrudHelper(this.table, {this.prefix = ''});

  Future<Map<dynamic, dynamic>> select({String? where});

  Future<Map> selectId(int id, {String? where});

  Future<int> insert(Map map);
  Future<void> replace(Map map);

  Future<void> delete({String? where});

  Future<void> deleteId(int id, {String? where});

  Future<void> update(Map map, {String? where});

  Future<int> count({String? where});

  Future<int> newId();
}
