import 'dart:io';
import 'package:flutter/material.dart';
import 'package:new_project_bro/my_app.dart';
import 'package:new_project_bro/pages/bolimlar_page.dart';
import 'package:new_project_bro/pages/contacts_page.dart';
import 'package:new_project_bro/pages/hamyon_page.dart';
import 'package:new_project_bro/pages/hisobotlaringiz.dart';
import 'package:new_project_bro/pages/kantakt_bolimlari.dart';
import 'package:new_project_bro/service/bolim_service.dart';
import 'package:new_project_bro/service/db_helper.dart';
import 'package:new_project_bro/service/kantakt_bolim_service.dart';
import 'package:new_project_bro/service/kantakt_service.dart';
import 'package:new_project_bro/service/karta.dart';
import 'package:new_project_bro/service/tushumchiqim.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory? directory;
  if (Platform.isWindows) {
    directory = await getApplicationSupportDirectory();
  } else {
    directory = await getApplicationDocumentsDirectory();
  }

  if (!await directory.exists()) {
    directory.create(recursive: true);
  }
  print("DB directory.path: ${directory.path}");
  DatabaseHelper().initDB(directory.path);
  runApp(const MyApp());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  List<TushumChiqim> hamyonObjectList = [];
  List<Kantakt> kantaktObjectList = [];
  List<Kantakt> kantaktObjectListt = [];
  List<Bolimlar> bolimObjectList = [];
  List<KantaktBolim> kantaktBolimObjectList = [];
  int _currentIndex = 0;
  num umumiyyigindi = 0;
  num kantaktyigindimusbat = 0;
  num kantaktyigindimanfiy = 0;
  Map<String, num> kantaktyigindi = {
    "musbat": 0,
    "manfiy": 0,
  };
  String _currentTab = 'Tushum';
  String _value = '';
  String _time = '';

  @override
  void initState() {
    super.initState();
    loadView();
  }

  Future<void> loadView() async {
    print('loadView');
    (await TushumChiqim.service.select()).forEach((key, value) {
      TushumChiqim.obyektlar[key] = TushumChiqim.fromJson(value);
    });
    (await Kantakt.service.select()).forEach((key, value) {
      Kantakt.obyektlar[key] = Kantakt.fromJson(value);
    });
    (await Karta.service.select()).forEach((key, value) {
      Karta.obyektlar[key] = Karta.fromJson(value);
    });
    (await Bolimlar.service.select()).forEach(
      (key, value) {
        Bolimlar.obyektlar[key] = Bolimlar.fromJson(value);
      },
    );

    loadFromGlobal();
  }

  Future<void> loadFromGlobal() async {
    hamyonObjectList = TushumChiqim.obyektlar.values.toList();
    kantaktObjectList = Kantakt.obyektlar.values.toList();
    bolimObjectList = Bolimlar.obyektlar.values.toList();
    kantaktBolimObjectList = KantaktBolim.obyektlar.values.toList();

    kantaktyigindimusbat = 0;
    kantaktyigindimanfiy = 0;
    for (Kantakt kantakt in Kantakt.obyektlar.values.toList()) {
      if (kantakt.price > 0) {
        kantaktyigindimusbat = kantaktyigindimusbat + kantakt.price;
      } else {
        kantaktyigindimanfiy = kantaktyigindimanfiy - kantakt.price;
      }
    }
    umumiyyigindi = 0;
    for (Karta karta in Karta.obyektlar.values.toList()) {
      umumiyyigindi += karta.price;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('FineMaster'),
      ),
      drawer: Drawer(
        shape: const BeveledRectangleBorder(),
        width: MediaQuery.sizeOf(context).width * .5,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'DRAWER',
                  style: TextStyle(
                      color: Colors.teal,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    "Bo'limlar",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BolimlarPage(title: ''),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    "Hisobotlar",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HisobotlaringizPage(
                          title: '',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Card(
                child: ListTile(
                  title: const Text(
                    "Kantakt bo'limlar",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KantaktBolimlarPage(
                          title: '',
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  focusColor: Colors.red,
                  hoverColor: Colors.teal.shade100,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HamyonsPage(title: ''),
                      ),
                    );
                    loadFromGlobal();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.teal.shade500,
                    ),
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const Text('Umumiy balans',
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              Text('$umumiyyigindi',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  focusColor: Colors.red,
                  hoverColor: Colors.teal.shade100,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KantaktPage(
                          title: '',
                        ),
                      ),
                    );
                    loadFromGlobal();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    width: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.teal.shade500,
                    ),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Tushum $kantaktyigindimusbat',
                            style: const TextStyle(
                                color: Color.fromARGB(255, 172, 209, 7),
                                fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'Kantakt',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Chiqim $kantaktyigindimanfiy',
                            style: const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: hamyonObjectList.length,
              itemBuilder: (context, index) {
                TushumChiqim hamyonObject = hamyonObjectList[index];
                Kantakt? kantaktObject;
                if (hamyonObject.idKantakt > 0) {
                  kantaktObject = Kantakt.obyektlar[hamyonObject.idKantakt];
                }
                Bolimlar? bolimObjectList =
                    Bolimlar.obyektlar[hamyonObject.idBolim];
                KantaktBolim? kantaktBolimObjectList =
                    KantaktBolim.obyektlar[hamyonObject.idKantaktBolim];
                Kantakt? kantaktObjectListt =
                    Kantakt.obyektlar[hamyonObject.idKantakt];
                TushumChiqim.obyektlar[hamyonObject.idBolim];
                return Card(
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Center(
                                  child: Text(
                                    'Sizning kiritgan malumotlaringiz',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24),
                                  ),
                                ),
                                Card(
                                  child: ListTile(
                                    title: Text(
                                      "${hamyonObject.price}",
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(hamyonObject.name),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                child: const Text('EDIT'),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  nameController.text = hamyonObject.name;
                                  priceController.text =
                                      hamyonObject.price.toString();
                                  (await Karta.service.select())
                                      .forEach((key, value) {
                                    Karta.obyektlar[key] =
                                        Karta.fromJson(value);
                                  });
                                  List<Karta> dropdownMenuList = [];
                                  List<Kantakt> dropdownMenuKontakts = [];
                                  List<Bolimlar> dropdownMenuBolim = [];
                                  for (Karta karta
                                      in Karta.obyektlar.values.toList()) {
                                    dropdownMenuList.add(karta);
                                  }
                                  for (Bolimlar bolimlar
                                      in Bolimlar.obyektlar.values.toList()) {
                                    dropdownMenuBolim.add(bolimlar);
                                  }
                                  for (Kantakt kantakt
                                      in Kantakt.obyektlar.values.toList()) {
                                    dropdownMenuKontakts.add(kantakt);
                                  }
                                  int? dropdownValue =
                                      dropdownMenuList.first.id;
                                  int? dropdownValue2 =
                                      dropdownMenuKontakts.first.id;
                                  int? dropdownValue3 =
                                      dropdownMenuBolim.first.id;
                                  _currentIndex = hamyonObject
                                      .tushummi_yoki_chiqimmi
                                      .toInt();
                                  await showDialog(
                                    // ignore: use_build_context_synchronously
                                    context: context,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return AlertDialog(
                                          title: const Text(
                                            'TAHRIRLASH',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(14),
                                                    ),
                                                  ),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<int>(
                                                    isDense: true,
                                                    isExpanded: true,
                                                    value: dropdownValue,
                                                    onChanged: (value) {
                                                      print(
                                                          "dropdownValue: $dropdownValue");
                                                      setState(() {
                                                        dropdownValue = value!;
                                                      });
                                                    },
                                                    items: dropdownMenuList.map<
                                                        DropdownMenuItem<
                                                            int>>((value) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value.id,
                                                        child: Text(value.name),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                "D'ostingizni tanlang",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(14),
                                                    ),
                                                  ),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<int>(
                                                    isDense: true,
                                                    isExpanded: true,
                                                    value: dropdownValue2,
                                                    onChanged: (value) {
                                                      print(
                                                          "dropdownValue2: $dropdownValue2");
                                                      setState(() {
                                                        dropdownValue2 = value!;
                                                      });
                                                    },
                                                    items: dropdownMenuKontakts
                                                        .map<
                                                            DropdownMenuItem<
                                                                int>>((value) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value.id,
                                                        child: Text(value.name),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Text(
                                                "Bo'limni tanlang",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              InputDecorator(
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14)),
                                                  ),
                                                ),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child: DropdownButton<int>(
                                                    isDense: true,
                                                    isExpanded: true,
                                                    value: dropdownValue3,
                                                    onChanged: (value) {
                                                      print(
                                                          "dropdownValue3: $dropdownValue3");
                                                      setState(() {
                                                        dropdownValue3 = value!;
                                                      });
                                                    },
                                                    items: dropdownMenuBolim
                                                        .map<
                                                            DropdownMenuItem<
                                                                int>>((value) {
                                                      return DropdownMenuItem<
                                                          int>(
                                                        value: value.id,
                                                        child: Text(value.name),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                controller: priceController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    hintText:
                                                        "Mablag'ni kiriting"),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextField(
                                                controller: nameController,
                                                decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    hintText: "Izoh kiriting"),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      print('update Hamyon');
                                                      num oldPrice =
                                                          hamyonObject.price;
                                                      TushumChiqim
                                                          updateTushum =
                                                          hamyonObject;
                                                      updateTushum.name =
                                                          nameController.text;
                                                      updateTushum
                                                          .price = num.tryParse(
                                                              priceController
                                                                  .text) ??
                                                          0;
                                                      print(
                                                          'Price bro: ${updateTushum.price}');
                                                      updateTushum.idKarta =
                                                          int.parse(
                                                              dropdownValue
                                                                  .toString());
                                                      updateTushum.vaqti =
                                                          "${DateTime.now().hour}:${DateTime.now().minute > 10 ? DateTime.now().minute : '0${DateTime.now().minute}'}";
                                                      updateTushum.idKantakt =
                                                          int.parse(
                                                              dropdownValue2
                                                                  .toString());
                                                      updateTushum.idBolim =
                                                          int.parse(
                                                              dropdownValue3
                                                                  .toString());
                                                      updateTushum
                                                              .tushummi_yoki_chiqimmi =
                                                          num.tryParse(_currentIndex
                                                                  .toString()) ??
                                                              0;
                                                      print(
                                                          "DROPDOWNVALUE2: ${dropdownValue2}");
                                                      print(
                                                          "DROPDOWNVALUE: ${dropdownValue}");
                                                      print(
                                                          "DROPDOWNVALUE3: ${dropdownValue3}");
                                                      print(
                                                          'tushummi yoki chiqimmi => ${updateTushum.tushummi_yoki_chiqimmi}');
                                                      await updateTushum
                                                          .update();
                                                      loadFromGlobal();
                                                      Karta minusYokiPlus = Karta
                                                              .obyektlar[
                                                          int.parse(dropdownValue
                                                              .toString())]!;
                                                      if (_currentIndex == 1) {
                                                        minusYokiPlus.price =
                                                            minusYokiPlus
                                                                    .price +
                                                                oldPrice;
                                                        minusYokiPlus.price =
                                                            minusYokiPlus
                                                                    .price -
                                                                updateTushum
                                                                    .price;
                                                      } else if (_currentIndex ==
                                                          0) {
                                                        minusYokiPlus.price =
                                                            minusYokiPlus
                                                                    .price -
                                                                oldPrice;
                                                        minusYokiPlus.price =
                                                            minusYokiPlus
                                                                    .price +
                                                                updateTushum
                                                                    .price;
                                                      }
                                                      await minusYokiPlus
                                                          .update();
                                                      Navigator.pop(context);
                                                      priceController.clear();
                                                      nameController.clear();
                                                      _currentIndex = 0;
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.lightBlue
                                                                    .shade100),
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.done),
                                                        Text('Saqlash')
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                    },
                                  );
                                  loadFromGlobal();
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("O'chirilsinmi"),
                                        content: const Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                                "O'chirmoqchi bo'lgan elementingizni qayta tiklab bo'lmaydii")
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('bekor qilish'),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                hamyonObject.delete();
                                                loadFromGlobal();
                                                Navigator.pop(context);
                                              },
                                              child: const Text("O'chirish"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: const Text("DELETE"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    subtitle: Text(
                      "Izohingiz: ${hamyonObject.name}\nBo'lim: ${bolimObjectList?.name.toString()}",
                    ),
                    title: hamyonObject.tushummi_yoki_chiqimmi == 0
                        ? Text(
                            "+${hamyonObject.price} UZS",
                            style: const TextStyle(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )
                        : Text(
                            "-${hamyonObject.price} UZS",
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                    trailing: hamyonObject.tushummi_yoki_chiqimmi == 0
                        ? Column(
                            children: [
                              if (kantaktObject != null)
                                Text(kantaktObject.name),
                              Text(hamyonObject.vaqti),
                            ],
                          )
                        : Column(
                            children: [
                              if (kantaktObject != null)
                                Text(kantaktObject.name),
                              Text(hamyonObject.vaqti),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text(
                      'Qanday qayd kiritamiz',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () async {
                            _currentIndex = 0;
                            _currentTab = 'Tushum';
                            setState(() {});
                            Navigator.pop(context);
                            nameController.text = '';
                            priceController.text = '';
                            (await Karta.service.select())
                                .forEach((key, value) {
                              Karta.obyektlar[key] = Karta.fromJson(value);
                            });
                            List<Karta> dropdownMenuList = [];
                            for (Karta karta
                                in Karta.obyektlar.values.toList()) {
                              dropdownMenuList.add(karta);
                            }
                            int? dropdownValue = dropdownMenuList.first.id;
                            List<Kantakt> dropdownMenuKontakts = [];
                            for (Kantakt kantakt
                                in Kantakt.obyektlar.values.toList()) {
                              dropdownMenuKontakts.add(kantakt);
                            }
                            int? dropdownValue2 = dropdownMenuKontakts.first.id;
                            List<Bolimlar> dropdownMenuBolim = [];
                            for (Bolimlar bolimlar
                                in Bolimlar.obyektlar.values.toList()) {
                              if (bolimlar.tushummi_yoki_chiqimmi == 0) {
                                dropdownMenuBolim.add(bolimlar);
                              }
                            }
                            int? dropdownValue3 = dropdownMenuBolim.first.id;
                            List<KantaktBolim> dropdownMenuBolimKantakt = [];
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Amal bajarish',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue: $dropdownValue");
                                                  setState(() {
                                                    dropdownValue = value!;
                                                  });
                                                },
                                                items: dropdownMenuList
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Do'stingizni tanlang",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue2,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue2: $dropdownValue2");
                                                  setState(
                                                    () {
                                                      dropdownValue2 = value!;
                                                    },
                                                  );
                                                },
                                                items: dropdownMenuKontakts
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Bo'limni tanlang",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue3,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue3: $dropdownValue3");
                                                  setState(() {
                                                    dropdownValue3 = value!;
                                                  });
                                                },
                                                items: dropdownMenuBolim
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                              hintText: "Summani kiriting",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: "Izoh kiriting",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .lightBlue.shade100),
                                                onPressed: () async {
                                                  print('insert new Hamyon');
                                                  TushumChiqim yangiTushum =
                                                      TushumChiqim();
                                                  yangiTushum.name =
                                                      nameController.text;

                                                  yangiTushum.price =
                                                      num.tryParse(
                                                              priceController
                                                                  .text) ??
                                                          0;
                                                  yangiTushum.idKarta =
                                                      int.parse(dropdownValue
                                                          .toString());
                                                  yangiTushum.idKantakt =
                                                      int.parse(dropdownValue2
                                                          .toString());
                                                  yangiTushum.idBolim =
                                                      int.parse(dropdownValue3
                                                          .toString());
                                                  yangiTushum
                                                          .tushummi_yoki_chiqimmi =
                                                      num.tryParse(_currentIndex
                                                              .toString()) ??
                                                          0;
                                                  yangiTushum.vaqti =
                                                      "${DateTime.now().hour}:${DateTime.now().minute > 10 ? DateTime.now().minute : '0${DateTime.now().minute}'}";
                                                  await yangiTushum.insert();
                                                  loadFromGlobal();
                                                  Karta minusYokiPlus = Karta
                                                      .obyektlar[(int.tryParse(
                                                    dropdownValue.toString(),
                                                  ))]!;
                                                  if (_currentIndex == 1) {
                                                    minusYokiPlus.price =
                                                        minusYokiPlus.price -
                                                            yangiTushum.price;
                                                  } else if (_currentIndex ==
                                                      0) {
                                                    minusYokiPlus.price =
                                                        minusYokiPlus.price +
                                                            yangiTushum.price;
                                                  }
                                                  await minusYokiPlus.update();
                                                  /* ========= */
                                                  Kantakt minusYokiPlusKantakt =
                                                      Kantakt.obyektlar[(int
                                                          .parse(dropdownValue2
                                                              .toString()))]!;
                                                  if (_currentIndex == 1) {
                                                    minusYokiPlusKantakt.price =
                                                        minusYokiPlusKantakt
                                                                .price -
                                                            yangiTushum.price;
                                                  } else if (_currentIndex ==
                                                      0) {
                                                    minusYokiPlusKantakt.price =
                                                        minusYokiPlusKantakt
                                                                .price +
                                                            yangiTushum.price;
                                                  }
                                                  await minusYokiPlusKantakt
                                                      .update();
                                                  Navigator.pop(context);
                                                  priceController.clear();
                                                  nameController.clear();
                                                  _currentIndex = 0;
                                                  _value =
                                                      minusYokiPlusKantakt.name;
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.done),
                                                    Text('Saqlash'),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                            loadFromGlobal();
                          },
                          child: const Text(
                            "TUSHUM ---->",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            _currentIndex = 1;
                            _currentTab = 'Chiqim';
                            setState(() {});
                            Navigator.pop(context);
                            nameController.text = '';
                            priceController.text = '';
                            (await Karta.service.select())
                                .forEach((key, value) {
                              Karta.obyektlar[key] = Karta.fromJson(value);
                            });
                            List<Karta> dropdownMenuList = [];
                            for (Karta karta
                                in Karta.obyektlar.values.toList()) {
                              dropdownMenuList.add(karta);
                            }
                            int? dropdownValue = dropdownMenuList.first.id;
                            List<Kantakt> dropdownMenuKontakts = [];
                            for (Kantakt kantakt
                                in Kantakt.obyektlar.values.toList()) {
                              dropdownMenuKontakts.add(kantakt);
                            }
                            int? dropdownValue2 = dropdownMenuKontakts.first.id;
                            List<Bolimlar> dropdownMenuBolim = [];
                            for (Bolimlar bolimlar
                                in Bolimlar.obyektlar.values.toList()) {
                              if (bolimlar.tushummi_yoki_chiqimmi == 1) {
                                dropdownMenuBolim.add(bolimlar);
                              }
                            }
                            int? dropdownValue3 = dropdownMenuBolim.first.id;
                            List<KantaktBolim> dropdownMenuBolimKantakt = [];
                            await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setState) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Amal bajarish',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue: $dropdownValue");
                                                  setState(() {
                                                    dropdownValue = value!;
                                                  });
                                                },
                                                items: dropdownMenuList
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          const Text(
                                            "Do'stingizni tanlang",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue2,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue2: $dropdownValue2");
                                                  setState(
                                                    () {
                                                      dropdownValue2 = value!;
                                                    },
                                                  );
                                                },
                                                items: dropdownMenuKontakts
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          const Text(
                                            "Bo'limni tanlang",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          InputDecorator(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(14)),
                                              ),
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<int>(
                                                isDense: true,
                                                isExpanded: true,
                                                value: dropdownValue3,
                                                onChanged: (value) {
                                                  print(
                                                      "dropdownValue3: $dropdownValue3");
                                                  setState(() {
                                                    dropdownValue3 = value!;
                                                  });
                                                },
                                                items: dropdownMenuBolim
                                                    .map<DropdownMenuItem<int>>(
                                                  (value) {
                                                    return DropdownMenuItem<
                                                        int>(
                                                      value: value.id,
                                                      child: Text(value.name),
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: priceController,
                                            decoration: InputDecoration(
                                              hintText: "Summani kiriting",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextField(
                                            controller: nameController,
                                            decoration: InputDecoration(
                                              hintText: "Izoh kiriting",
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors
                                                        .lightBlue.shade100),
                                                onPressed: () async {
                                                  print('insert new Hamyon');
                                                  TushumChiqim yangiTushum =
                                                      TushumChiqim();
                                                  yangiTushum.name =
                                                      nameController.text;

                                                  yangiTushum.price =
                                                      num.tryParse(
                                                              priceController
                                                                  .text) ??
                                                          0;
                                                  yangiTushum.idKarta =
                                                      int.parse(dropdownValue
                                                          .toString());
                                                  yangiTushum.idKantakt =
                                                      int.parse(dropdownValue2
                                                          .toString());
                                                  yangiTushum.idBolim =
                                                      int.parse(dropdownValue3
                                                          .toString());
                                                  yangiTushum
                                                          .tushummi_yoki_chiqimmi =
                                                      num.tryParse(_currentIndex
                                                              .toString()) ??
                                                          0;
                                                  yangiTushum.vaqti =
                                                      '${DateTime.now().hour}:${DateTime.now().minute}';
                                                  await yangiTushum.insert();
                                                  loadFromGlobal();
                                                  Karta minusYokiPlus = Karta
                                                      .obyektlar[(int.tryParse(
                                                    dropdownValue.toString(),
                                                  ))]!;
                                                  if (_currentIndex == 1) {
                                                    minusYokiPlus.price =
                                                        minusYokiPlus.price -
                                                            yangiTushum.price;
                                                  } else if (_currentIndex ==
                                                      0) {
                                                    minusYokiPlus.price =
                                                        minusYokiPlus.price +
                                                            yangiTushum.price;
                                                  }
                                                  await minusYokiPlus.update();
                                                  /* ========= */
                                                  Kantakt minusYokiPlusKantakt =
                                                      Kantakt.obyektlar[(int
                                                          .parse(dropdownValue2
                                                              .toString()))]!;
                                                  if (_currentIndex == 1) {
                                                    minusYokiPlusKantakt.price =
                                                        minusYokiPlusKantakt
                                                                .price -
                                                            yangiTushum.price;
                                                  } else if (_currentIndex ==
                                                      0) {
                                                    minusYokiPlusKantakt.price =
                                                        minusYokiPlusKantakt
                                                                .price +
                                                            yangiTushum.price;
                                                  }
                                                  await minusYokiPlusKantakt
                                                      .update();
                                                  Navigator.pop(context);
                                                  priceController.clear();
                                                  nameController.clear();
                                                  _currentIndex = 0;
                                                  _value =
                                                      minusYokiPlusKantakt.name;
                                                },
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.done),
                                                    Text('Saqlash'),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                            loadFromGlobal();
                          },
                          child: const Text(
                            "CHIQIM <----",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
          loadFromGlobal();
        },
        child: const Text('+'),
      ),
    );
  }
}
