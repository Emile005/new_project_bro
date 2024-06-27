import 'package:flutter/material.dart';
import 'package:new_project_bro/service/bolim_service.dart';
import 'package:new_project_bro/service/tushumchiqim.dart';

class HisobotlaringizPage extends StatefulWidget {
  const HisobotlaringizPage({super.key, required this.title});
  final String title;
  @override
  State<HisobotlaringizPage> createState() => _HisobotlaringizPageState();
}

class _HisobotlaringizPageState extends State<HisobotlaringizPage> {
  int _currentIndex = 0;
  List<double> bolimobjectlistpilus = [];
  List<double> bolimobjectlistminus = [];
  num oldprice = 0;
  String nomii = '';
  num bolimyigindimanfiy = 0;
  num bolimyigindimusbat = 0;

  Map<int, double> bolimTushumSummalari = {};
  Map<int, double> bolimChiqimSummalri = {};

  Map<int, double> bolimSummalariMinus = {};
  Map<int, double> bolimSummalariPilus = {};

  @override
  void initState() {
    super.initState();
    loadFromGlobal();
  }

  Future<void> loadFromGlobal() async {
    for (TushumChiqim tushumchiqim in TushumChiqim.obyektlar.values.toList()) {
      print(tushumchiqim.toJson());
      if (tushumchiqim.tushummi_yoki_chiqimmi == 0) {
        bolimTushumSummalari[tushumchiqim.idBolim] = tushumchiqim.price +
            (bolimTushumSummalari[tushumchiqim.idBolim] ?? 0);
      } else {
        bolimChiqimSummalri[tushumchiqim.idBolim] = tushumchiqim.price +
            (bolimChiqimSummalri[tushumchiqim.idBolim] ?? 0);
      }
    }

    for (TushumChiqim tushumchiqimm in TushumChiqim.obyektlar.values.toList()) {
      if (tushumchiqimm.tushummi_yoki_chiqimmi == _currentIndex) {
        bolimobjectlistpilus.add(tushumchiqimm.price.toDouble());
      } else {
        bolimobjectlistminus.add(tushumchiqimm.price.toDouble());
      }
    }

    for (var element in bolimobjectlistpilus) {
      bolimyigindimusbat += element;
    }
    for (var element in bolimobjectlistminus) {
      bolimyigindimanfiy += element;
    }

    print('bolimobjectlistpilus $bolimobjectlistpilus');
    print('bolimobjectlistminus $bolimobjectlistminus');
    print('bolimTUSHUMLARSUMMALAR $bolimTushumSummalari');
    print('bolimCHIQIMLARSUMMALAR  $bolimChiqimSummalri');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Finmaster'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, left: 30),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      border: const Border.fromBorderSide(
                          BorderSide(color: Colors.green)),
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text('Tushum'),
                        Text('$bolimyigindimusbat')
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  Container(
                    height: 50,
                    width: MediaQuery.of(context).size.width * .4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      border: const Border.fromBorderSide(
                          BorderSide(color: Colors.green)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const Text('Chiqim'),
                        Text('$bolimyigindimanfiy')
                      ],
                    ),
                  ),
                ],
              ),
              const Text('Tushum'),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Expanded(
                    child: ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: bolimTushumSummalari.length,
                      itemBuilder: (context, index) {
                        Bolimlar bolim = Bolimlar.obyektlar[
                            bolimTushumSummalari.keys.toList()[index]]!;
                        double summa =
                            bolimTushumSummalari.values.toList()[index];
                        return Column(
                          children: [
                            Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    subtitle: Row(
                                      children: [
                                        Text(bolim.name),
                                        const Spacer(),
                                        Text("$summa"),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              const Divider(),
              const SizedBox(height: 15),
              const Text('Chiqim'),
              const SizedBox(
                height: 10,
              ),
              Card(
                child: Expanded(
                  child: ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bolimChiqimSummalri.length,
                    itemBuilder: (context, index) {
                      Bolimlar bolim = Bolimlar
                          .obyektlar[bolimChiqimSummalri.keys.toList()[index]]!;
                      double summa = bolimChiqimSummalri.values.toList()[index];
                      return Column(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                ListTile(
                                  // title: const Center(
                                  //   child: Text("Chiqim"),
                                  // ),
                                  subtitle: Row(
                                    children: [
                                      Text(bolim.name),
                                      const Spacer(),
                                      Text("$summa"),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
