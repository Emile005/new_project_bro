import 'package:flutter/material.dart';
import 'package:new_project_bro/service/bolim_service.dart';

class BolimlarPage extends StatefulWidget {
  const BolimlarPage({super.key, required this.title});
  final String title;
  @override
  State<BolimlarPage> createState() => _BolimlarPageState();
}

class _BolimlarPageState extends State<BolimlarPage> {
  List<Bolimlar> bolimObjectList = [];
  int _currentIndex = 0;
  // ignore: unused_field
  String _currentTab = 'Tushum';
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadView();
  }

  Future<void> loadView() async {
    print('loadView');
    (await Bolimlar.service.select()).forEach((key, value) {
      Bolimlar.obyektlar[key] = Bolimlar.fromJson(value);
    });
    loadFromGlobal();
  }

  Future<void> loadFromGlobal() async {
    print('loadFromGlobal');
    bolimObjectList = Bolimlar.obyektlar.values.toList();
    setState(() {
      bolimObjectList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Bo'limlaringiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bolimObjectList.length,
              itemBuilder: (context, index) {
                Bolimlar bolimObject = bolimObjectList[index];
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
                                        bolimObject.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      trailing: bolimObject
                                                  .tushummi_yoki_chiqimmi ==
                                              0
                                          ? const Text(
                                              'Tushum',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            )
                                          : const Text(
                                              "Chiqim",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                    ),
                                  ),
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
                                        nameController.text = bolimObject.name;
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return StatefulBuilder(
                                                builder: (BuildContext context,
                                                    StateSetter setState) {
                                                  return AlertDialog(
                                                    title: const Text(
                                                        "Malumotlarni to'ldiring"),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Container(
                                                          height: 45,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          14),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .grey)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _currentIndex =
                                                                          0;
                                                                      _currentTab =
                                                                          'Tushum';
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: _currentIndex == 0
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .transparent,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Tushum',
                                                                        style:
                                                                            TextStyle(
                                                                          color: _currentIndex == 0
                                                                              ? Colors.white
                                                                              : Colors.black,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      _currentIndex =
                                                                          1;
                                                                      _currentTab =
                                                                          'Chiqim';
                                                                      setState(
                                                                          () {});
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: _currentIndex == 1
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .transparent,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              14),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        'Chiqim',
                                                                        style:
                                                                            TextStyle(
                                                                          color: _currentIndex == 1
                                                                              ? Colors.white
                                                                              : Colors.red,
                                                                        ),
                                                                      ),
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
                                                        TextField(
                                                          controller:
                                                              nameController,
                                                          decoration:
                                                              InputDecoration(
                                                                  border:
                                                                      OutlineInputBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            14),
                                                                  ),
                                                                  hintText:
                                                                      "Bo'limni kiriting"),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                bolimObject
                                                                        .name =
                                                                    nameController
                                                                        .text;
                                                                bolimObject
                                                                        .tushummi_yoki_chiqimmi =
                                                                    num.tryParse(
                                                                            _currentIndex.toString()) ??
                                                                        0;
                                                                await bolimObject
                                                                    .update();
                                                                loadFromGlobal();
                                                                Navigator.pop(
                                                                    context);
                                                                nameController
                                                                    .clear();
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors
                                                                      .lightBlue
                                                                      .shade100),
                                                              child: const Row(
                                                                children: [
                                                                  Icon(Icons
                                                                      .done),
                                                                  Text(
                                                                      'Saqlash')
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
                                                  child: const Text(
                                                      'bekor qilish'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    bolimObject.delete();
                                                    loadFromGlobal();
                                                    Navigator.pop(context);
                                                  },
                                                  child:
                                                      const Text("O'chirish"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                          "O'chirish uchun ustiga bosing"),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: Text(
                      bolimObject.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    trailing: bolimObject.tushummi_yoki_chiqimmi == 0
                        ? const Text(
                            'Tushum',
                            style: TextStyle(color: Colors.green),
                          )
                        : const Text(
                            "Chiqim",
                            style: TextStyle(color: Colors.red),
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
          nameController.text = '';
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return AlertDialog(
                      title: const Text("Malumotlarni to'ldiring"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.grey)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _currentIndex = 0;
                                        _currentTab = 'Tushum';
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _currentIndex == 0
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Tushum',
                                          style: TextStyle(
                                            color: _currentIndex == 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _currentIndex = 1;
                                        _currentTab = 'Chiqim';
                                        setState(() {});
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _currentIndex == 1
                                            ? Colors.blue
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Chiqim',
                                          style: TextStyle(
                                            color: _currentIndex == 1
                                                ? Colors.white
                                                : Colors.red,
                                          ),
                                        ),
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
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                hintText: "Bo'limni kiriting"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  Bolimlar yangiBolim = Bolimlar();
                                  yangiBolim.name = nameController.text;
                                  yangiBolim.tushummi_yoki_chiqimmi =
                                      num.tryParse(_currentIndex.toString()) ??
                                          0;
                                  await yangiBolim.insert();
                                  loadFromGlobal();
                                  Navigator.pop(context);
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
              });
        },
        child: const Text('+'),
      ),
    );
  }
}
