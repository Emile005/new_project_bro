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
  Map<int, String> bolimkantaktlarii = {};

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
    setState(() {
      kantaktbolimObjectList;
      kantaktObjectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Kantakt bo'limlaringiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        children: [
          const Text('Teks'),
          Expanded(
            child: ListView.builder(
              itemCount: kantaktbolimObjectList.length,
              itemBuilder: (context, index) {
                KantaktBolim kantaktObject = kantaktbolimObjectList[index];
                return Card(
                  child: ListTile(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter setState) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      height: 200,
                                      width: 150,
                                      child: Column(
                                        children: [
                                          const Text(
                                              "Sizning bo'limdagi kantaktlaringiz"),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemBuilder: (context, index) {
                                                return Card(
                                                  child: ListTile(
                                                    title: Text(kantaktObject.id
                                                        .toString()),
                                                    subtitle: Text(
                                                        kantaktObject.name),
                                                  ),
                                                );
                                              },
                                              itemCount:
                                                  bolimkantaktlarii.length,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          });
                    },
                    onLongPress: () {
                      kantaktObject.delete();
                      loadFromGlobal();
                    },
                    title: Text(kantaktObject.name),
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
                        Container(
                          height: 400,
                          width: 300,
                          child: Expanded(
                            child: ListView.builder(
                              itemBuilder: (context, index) {
                                Kantakt kantaktObject =
                                    kantaktObjectList[index];
                                return Card(
                                  child: ListTile(
                                    onLongPress: () {
                                      kantaktObject.delete();
                                      loadFromGlobal();
                                      Navigator.pop(context);
                                    },
                                    title: Text(kantaktObject.name),
                                    subtitle: ElevatedButton(
                                        onPressed: () {
                                          print(
                                              'kantaktobject.name:    ${kantaktObject.name}');
                                          kantaktObject.tanlov = 1;
                                          loadFromGlobal();
                                          print(
                                              "kantaktobject.tanlov:   ${kantaktObject.tanlov}   . ${kantaktObject.name}}");
                                          if (kantaktObject.tanlov == 1) {
                                            bolimkantaktlarii.addAll({
                                              kantaktObject.id:
                                                  kantaktObject.name
                                            });
                                          }
                                          kantaktObject.insert();
                                          print(
                                              'bolimKantaktlari:    ${bolimkantaktlarii}');
                                          'BOLIMKONTAKTLARI:    ${bolimkantaktlarii}';
                                        },
                                        child: const Text("Qo'shish")),
                                  ),
                                );
                              },
                              itemCount: kantaktObjectList.length,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  KantaktBolim yangiKantaktBolim =
                                      KantaktBolim();
                                  yangiKantaktBolim.name = nameController.text;
                                  await yangiKantaktBolim.insert();
                                  loadFromGlobal();
                                  nameController.clear();
                                  Navigator.pop(context);
                                },
                                child: const Text('Saqlash'))
                          ],
                        )
                      ],
                    ),
                  );
                });
              });
        },
        child: const Text('+'),
      ),
    );
  }
}
