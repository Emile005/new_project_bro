// ignore: depend_on_referenced_packages

import 'package:new_project_bro/service/bolim_service.dart';
import 'package:new_project_bro/service/kantakt_bolim_service.dart';
import 'package:new_project_bro/service/kantakt_service.dart';
import 'package:new_project_bro/service/karta.dart';
import 'package:new_project_bro/service/tushumchiqim.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';
import 'package:path/path.dart';

SQLiteWrapper db = SQLiteWrapper();

class DatabaseHelper {
  static const int version = 1;
  static final DatabaseHelper _singleton = DatabaseHelper._internal();
  factory DatabaseHelper() {
    return _singleton;
  }

  DatabaseHelper._internal();

  Future<DatabaseInfo> initDB(dbPath, {inMemory = false}) async {
    dbPath = join(dbPath, "base.sqlite");

    return await db.openDB(
      dbPath,
      version: version,
      onCreate: () => _create(),
      onUpgrade: (fromVersion, toVersion) async {},
    );
  }

  _create() async {
    List<String> sql = [];
    sql.add(TushumChiqimService.createTable);
    sql.add(KartaService.createTable);
    sql.add(KantaktService.createTable);
    sql.add(BolimlarService.createTable);
    sql.add(KantaktBolimService.createTable);
    for (var query in sql) {
      await db.execute(query);
    }

    Karta yangiKarta = Karta();
    yangiKarta.name = "Asaka bank karta";
    yangiKarta.price = 1000000;
    yangiKarta.vaqti = '${DateTime.now().hour}:${DateTime.now().minute}';
    await yangiKarta.insert();
    Karta sKarta = Karta();
    sKarta.name = "Humo bank karta";
    sKarta.price = 0;
    sKarta.vaqti = '${DateTime.now().hour}:${DateTime.now().minute}';
    await sKarta.insert();
    Kantakt birinchiDefaultKantakt = Kantakt();
    birinchiDefaultKantakt.name = "Abu Bakir";
    birinchiDefaultKantakt.price = 10000000;
    birinchiDefaultKantakt.vaqti =
        '${DateTime.now().hour}:${DateTime.now().minute}';
    await birinchiDefaultKantakt.insert();
    Kantakt ikkinchifefaultKantakt = Kantakt();
    ikkinchifefaultKantakt.name = "Umar";
    ikkinchifefaultKantakt.price = 10000000;
    ikkinchifefaultKantakt.vaqti =
        '${DateTime.now().hour}:${DateTime.now().minute}';
    await ikkinchifefaultKantakt.insert();
    Kantakt uchinchiDefaultKantakt = Kantakt();
    uchinchiDefaultKantakt.name = "Usmon";
    uchinchiDefaultKantakt.price = 10000000;
    uchinchiDefaultKantakt.vaqti =
        '${DateTime.now().hour}:${DateTime.now().minute}';
    await uchinchiDefaultKantakt.insert();
    Bolimlar birinchiDefaultBolim = Bolimlar();
    birinchiDefaultBolim.name = "Oziq-ovqat";
    birinchiDefaultBolim.tushummi_yoki_chiqimmi = 1;
    await birinchiDefaultBolim.insert();
    Bolimlar ikkinchiDefaultBolim = Bolimlar();
    ikkinchiDefaultBolim.name = "Transport";
    ikkinchiDefaultBolim.tushummi_yoki_chiqimmi = 0;
    await ikkinchiDefaultBolim.insert();
    Bolimlar uchinchiDefaultBolim = Bolimlar();
    uchinchiDefaultBolim.name = "Turar-joy";
    uchinchiDefaultBolim.tushummi_yoki_chiqimmi = 0;
    await uchinchiDefaultBolim.insert();
    KantaktBolim birinchiDefaultKantaktBolim = KantaktBolim();
    birinchiDefaultKantaktBolim.name = 'Hamkasblar';
    birinchiDefaultKantaktBolim.tartib_raqam = 0;
    await birinchiDefaultKantaktBolim.insert();
    KantaktBolim ikkinchiDefaultKantaktBolim = KantaktBolim();
    ikkinchiDefaultKantaktBolim.name = 'Insonlar';
    ikkinchiDefaultKantaktBolim.tartib_raqam = 0;
    await ikkinchiDefaultKantaktBolim.insert();
    KantaktBolim uchinchiDefaultKantaktBolim = KantaktBolim();
    uchinchiDefaultKantaktBolim.name = "Do'stlar";
    uchinchiDefaultKantaktBolim.tartib_raqam = 0;
    await uchinchiDefaultKantaktBolim.insert();
    KantaktBolim tortinchiDefaultKantaktBolim = KantaktBolim();
    tortinchiDefaultKantaktBolim.name = 'Qarindoshlar';
    tortinchiDefaultKantaktBolim.tartib_raqam = 0;
    await tortinchiDefaultKantaktBolim.insert();
  }
}
