import 'package:flutter/material.dart';
import 'package:new_project_bro/service/karta.dart';

class HamyonsPage extends StatefulWidget {
  const HamyonsPage({super.key, required this.title});
  final String title;
  @override
  State<HamyonsPage> createState() => _HamyonsPageState();
}

class _HamyonsPageState extends State<HamyonsPage> {
  List<Karta> kartaObjectList = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  int result = 0;

  @override
  void initState() {
    super.initState();

    loadView();
  }

  Future<void> loadView() async {
    print('loadView');

    (await Karta.service.select()).forEach((key, value) {
      Karta.obyektlar[key] = Karta.fromJson(value);
    });
    loadFromGlobal();
  }

  _hisoblash() {}
  Future<void> loadFromGlobal() async {
    print('loadFromGlobal');

    kartaObjectList = Karta.obyektlar.values.toList();
    // hamyonObjectList.sort((a, b) => -b.id.compareTo(a.id));
    setState(() {
      kartaObjectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          'Hamyonlaringiz',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: kartaObjectList.length,
              itemBuilder: (context, index) {
                Karta kartaObject = kartaObjectList[index];
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
                                          fontSize: 14),
                                    ),
                                  ),
                                  Card(
                                    child: ListTile(
                                      title: Text(
                                        '${kartaObject.price}',
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(kartaObject.name),
                                      trailing: Text(kartaObject.vaqti),
                                    ),
                                  )
                                ],
                              ),
                              actions: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        nameController.text = kartaObject.name;
                                        priceController.text =
                                            kartaObject.price.toString();
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text('Amal bajarish'),
                                                actions: [
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: priceController,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        hintText:
                                                            "Mablag' kiriting"),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14)),
                                                        hintText:
                                                            "Izoh yozing"),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Karta updateKarta =
                                                              kartaObject;
                                                          updateKarta.name =
                                                              nameController
                                                                  .text;
                                                          updateKarta
                                                              .price = num.tryParse(
                                                                  priceController
                                                                      .text) ??
                                                              0;
                                                          updateKarta.vaqti =
                                                              '${DateTime.now().hour}:${DateTime.now().minute}';
                                                          setState(() {
                                                            updateKarta
                                                                .update();
                                                            Navigator.pop(
                                                                context);
                                                          });
                                                          priceController
                                                              .clear();
                                                          nameController
                                                              .clear();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Colors.teal
                                                                        .shade100),
                                                        child: const Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
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
                                              );
                                            });
                                      },
                                      child: const Text(
                                          'Tahrirlash uchun ustiga bosing'),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title:
                                                    const Text("O'chirilsinmi"),
                                                content: const Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
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
                                                    child: const Text(
                                                        'bekor qilish'),
                                                  ),
                                                  TextButton(
                                                      onPressed: () {
                                                        kartaObject.delete();
                                                        loadFromGlobal();
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                          "O'chirish"))
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: const Text(
                                            "O'chirish uchun ustiga bosing"))
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: Text(
                      '${kartaObject.price}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(kartaObject.name),
                    trailing: Text(kartaObject.vaqti),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          nameController.text = '';
          priceController.text = '';
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Malumotlarni to'ldiring"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: priceController,
                      decoration: InputDecoration(
                        hintText: "Pul miqdorini kiriting",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          hintText: "Hamyon nomini kiriting"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print('insert new Hamyon');
                            Karta yangiKarta = Karta();
                            yangiKarta.name = nameController.text;
                            yangiKarta.price =
                                num.tryParse(priceController.text) ?? 0;
                            yangiKarta.vaqti =
                                '${DateTime.now().hour}:${DateTime.now().minute}';
                            await yangiKarta.insert();
                            loadFromGlobal();
                            Navigator.pop(context);
                            priceController.clear();
                            nameController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade100),
                          child: const Row(
                            children: [Icon(Icons.done), Text('Saqlash')],
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
        child: const Text('+'),
      ),
    );
  }
}
