import 'package:flutter/material.dart';
import 'package:new_project_bro/service/kantakt_bolim_service.dart';
import 'package:new_project_bro/service/kantakt_service.dart';

class KantaktBolimlarPage extends StatefulWidget {
  const KantaktBolimlarPage({super.key, required this.title});
  final String title;
  @override
  State<KantaktBolimlarPage> createState() => _KantaktBolimlarPageState();
}

class _KantaktBolimlarPageState extends State<KantaktBolimlarPage> {
  final TextEditingController nameController = TextEditingController();
  List<KantaktBolim> kantaktbolimObjectList = [];
  List<Kantakt> kantaktObjectList = [];
  List<num> sum = [];
  Map<int, double> bolimTushumSummalariPilus = {};
  Map<int, double> bolimTushumSummalariMinus = {};
  Map<int, double> bolimChiqimSummalriPilus = {};
  Map<int, double> bolimChiqimSummalriMinus = {};
  num umumiyyigindi = 0;
  num umumiyyigindii = 0;
  int yigindi = 0;

  @override
  void initState() {
    super.initState();
    loadView();
  }

  Future<void> loadView() async {
    print('loadView');

    (await KantaktBolim.service.select()).forEach((key, value) {
      KantaktBolim.obyektlar[key] = KantaktBolim.fromJson(value);
    });
    (await Kantakt.service.select()).forEach((key, value) {
      Kantakt.obyektlar[key] = Kantakt.fromJson((value));
    });
    loadFromGlobal();
  }

  Future<void> loadFromGlobal() async {
    print('loadFromGlobal');
    kantaktbolimObjectList = KantaktBolim.obyektlar.values.toList();
    kantaktObjectList = Kantakt.obyektlar.values.toList();
    umumiyyigindi = 0;
    for (Kantakt tushumchiqim in Kantakt.obyektlar.values.toList()) {
      print(tushumchiqim.toJson());
      umumiyyigindi += tushumchiqim.price;
      if (tushumchiqim.idKantakt == tushumchiqim.idKantakt) {
        if (tushumchiqim.price > 0) {
          bolimTushumSummalariPilus[tushumchiqim.idKantakt] =
              tushumchiqim.price +
                  (bolimTushumSummalariPilus[tushumchiqim.idKantakt] ?? 0);
        } else {
          bolimTushumSummalariMinus[tushumchiqim.idKantakt] =
              tushumchiqim.price +
                  (bolimTushumSummalariMinus[tushumchiqim.idKantakt] ?? 0);
        }
        sum.add(tushumchiqim.price);
        print("sum: ${sum}");
      }
    }

    setState(
      () {
        kantaktbolimObjectList;
        kantaktObjectList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Column(
          children: [
            const Text(
              "Umumiy kantaktbo'limlar yig'indisi",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text("$umumiyyigindi"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: kantaktbolimObjectList.length,
        itemBuilder: (context, index) {
          KantaktBolim kantaktObject = kantaktbolimObjectList[index];
          double summa = bolimTushumSummalariPilus[kantaktObject.id] ?? 0;
          double summ = bolimTushumSummalariMinus[kantaktObject.id] ?? 0;
          return Card(
            child: ListTile(
              onLongPress: () {
                kantaktObject.delete();
                loadFromGlobal();
              },
              title: Text(
                kantaktObject.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Row(
                children: [
                  Text(
                    '$summa',
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "$summ",
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text("Ma'lumotlarni to'ldiring"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: "Bo'lim nomini kiriting",
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                KantaktBolim yangiKantaktBolim = KantaktBolim();
                                yangiKantaktBolim.name = nameController.text;
                                await yangiKantaktBolim.insert();
                                loadFromGlobal();
                                nameController.clear();
                                Navigator.pop(context);
                              },
                              child: const Text('Saqlash'),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Text('+'),
      ),
    );
  }
}
