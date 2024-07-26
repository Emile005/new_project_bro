import 'package:flutter/material.dart';
import 'package:new_project_bro/service/bolim_service.dart';
import 'package:new_project_bro/service/kantakt_bolim_service.dart';
import 'package:new_project_bro/service/kantakt_service.dart';

class KantaktPage extends StatefulWidget {
  const KantaktPage({super.key, required this.title});
  final String title;
  @override
  State<KantaktPage> createState() => _KantaktPageState();
}

class _KantaktPageState extends State<KantaktPage> {
  List<Kantakt> kantaktObjectList = [];
  List<Bolimlar> bolimObjectList = [];
  List<KantaktBolim> kantaktBolimObjectList = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadView();
  }

  Future<void> loadView() async {
    print('loadView');
    (await Kantakt.service.select()).forEach(
      (key, value) {
        Kantakt.obyektlar[key] = Kantakt.fromJson(value);
      },
    );
    (await Bolimlar.service.select()).forEach(
      (key, value) {
        Bolimlar.obyektlar[key] = Bolimlar.fromJson(value);
      },
    );

    loadFromGlobal();
  }

  Future<void> loadFromGlobal() async {
    print('loadFromGlobal');
    kantaktObjectList = Kantakt.obyektlar.values.toList();
    kantaktBolimObjectList = KantaktBolim.obyektlar.values.toList();
    setState(
      () {
        kantaktObjectList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text(
          "Kantaktlaringiz",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: kantaktObjectList.length,
              itemBuilder: (context, index) {
                Kantakt kantaktObject = kantaktObjectList[index];
                KantaktBolim? kantaktBolimObjectList =
                    KantaktBolim.obyektlar[kantaktObject.idKantakt];
                Kantakt.obyektlar[kantaktObject.idKantakt];
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
                                      title: kantaktObject.price > 0
                                          ? Text(
                                              "${kantaktObject.price}",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          : Text(
                                              "${kantaktObject.price}",
                                              style: const TextStyle(
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            ),
                                      subtitle: Text(kantaktObject.name),
                                      trailing: Text(kantaktObject.vaqti),
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
                                        nameController.text =
                                            kantaktObject.name;
                                        priceController.text =
                                            kantaktObject.price.toString();
                                        List<KantaktBolim>
                                            dropdownMenuBolimKantakt = [];
                                        for (KantaktBolim kantaktBolim
                                            in KantaktBolim.obyektlar.values
                                                .toList()) {
                                          dropdownMenuBolimKantakt
                                              .add(kantaktBolim);
                                        }
                                        int? dropdownValue4 =
                                            dropdownMenuBolimKantakt.first.id;
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
                                                            "Pul miqdorini kiriting"),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  TextField(
                                                    controller: nameController,
                                                    decoration: InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(14),
                                                        ),
                                                        hintText:
                                                            "Izoh yozing"),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  InputDecorator(
                                                    decoration:
                                                        const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    14)),
                                                      ),
                                                    ),
                                                    child:
                                                        DropdownButtonHideUnderline(
                                                      child:
                                                          DropdownButton<int>(
                                                        isDense: true,
                                                        isExpanded: true,
                                                        value: dropdownValue4,
                                                        onChanged: (value) {
                                                          print(
                                                              "dropdownValue4: $dropdownValue4");
                                                          setState(() {
                                                            dropdownValue4 =
                                                                value!;
                                                          });
                                                        },
                                                        items: dropdownMenuBolimKantakt
                                                            .map<
                                                                DropdownMenuItem<
                                                                    int>>((value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value.id,
                                                            child: Text(
                                                                value.name),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Kantakt
                                                              updateKantakt =
                                                              kantaktObject;
                                                          updateKantakt.vaqti =
                                                              "${DateTime.now().hour}:${DateTime.now().minute > 10 ? DateTime.now().minute : '0${DateTime.now().minute}'}";
                                                          updateKantakt.name =
                                                              nameController
                                                                  .text;
                                                          updateKantakt
                                                              .price = num.tryParse(
                                                                  priceController
                                                                      .text) ??
                                                              0;
                                                          updateKantakt
                                                                  .idKantakt =
                                                              int.parse(
                                                                  dropdownValue4
                                                                      .toString());
                                                          print(
                                                              "DROPDOWNVALUE4: ${dropdownValue4}");
                                                          setState(() {
                                                            updateKantakt
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
                                                                    Colors
                                                                        .lightBlue
                                                                        .shade100),
                                                        child: const Row(
                                                          children: [
                                                            Icon(Icons.done),
                                                            Text("Saqlash")
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
                                      child: const Text('EDIT'),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
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
                                                      kantaktObject.delete();
                                                      loadFromGlobal();
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        const Text("O'chirish"))
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: const Text("DELETE"),
                                    ),
                                  ],
                                )
                              ],
                            );
                          });
                    },
                    title: kantaktObject.price > 0
                        ? Text(
                            "${kantaktObject.price}",
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          )
                        : Text(
                            "${kantaktObject.price}",
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                    subtitle: Text(
                        "${kantaktObject.name}\nidkantaktBolim: ${kantaktBolimObjectList?.name.toString()}"),
                    trailing: Text(kantaktObject.vaqti),
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
          priceController.text = '';
          List<KantaktBolim> dropdownMenuBolimKantakt = [];
          for (KantaktBolim kantaktBolimlar
              in KantaktBolim.obyektlar.values.toList()) {
            dropdownMenuBolimKantakt.add(kantaktBolimlar);
          }
          int? dropdownValue4 = dropdownMenuBolimKantakt.first.id;
          await showDialog(
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
                          hintText: "Izoh yozing"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InputDecorator(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<int>(
                          isDense: true,
                          isExpanded: true,
                          value: dropdownValue4,
                          onChanged: (value) {
                            print("dropdownValue4: $dropdownValue4");
                            setState(() {
                              dropdownValue4 = value!;
                            });
                          },
                          items: dropdownMenuBolimKantakt
                              .map<DropdownMenuItem<int>>(
                            (value) {
                              return DropdownMenuItem<int>(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            print('insert new Hamyon');
                            Kantakt yangiKantakt = Kantakt();
                            yangiKantakt.name = nameController.text;
                            yangiKantakt.price =
                                num.tryParse(priceController.text) ?? 0;
                            yangiKantakt.idKantakt =
                                int.parse(dropdownValue4.toString());
                            print("Yangikantakt name: ${yangiKantakt.name}");
                            print("Yangikantakt price: ${yangiKantakt.price}");
                            yangiKantakt.vaqti =
                                "${DateTime.now().hour}:${DateTime.now().minute > 10 ? DateTime.now().minute : '0${DateTime.now().minute}'}";
                            print("${yangiKantakt.vaqti} vaqt");
                            await yangiKantakt.insert();
                            loadFromGlobal();
                            Navigator.pop(context);
                            priceController.clear();
                            nameController.clear();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.lightBlue.shade100),
                          child: const Row(
                            children: [Icon(Icons.done), Text("Saqlash")],
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
          loadFromGlobal();
        },
        child: const Text('+'),
      ),
    );
  }
}
