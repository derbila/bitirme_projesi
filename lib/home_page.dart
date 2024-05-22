import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'functions.dart';
import 'home_child.dart';
import 'otuz_gun_hesaplama.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController enlemController = TextEditingController();
  TextEditingController rakimController = TextEditingController();
  TextEditingController ruzgarHizi10mController = TextEditingController();
  TextEditingController minRhController = TextEditingController();
  TextEditingController maxRhController = TextEditingController();
  TextEditingController minSicaklikController = TextEditingController();
  TextEditingController maxSicaklikController = TextEditingController();
  TextEditingController gunlukGuneslenmeSuresiController = TextEditingController();
  TextEditingController gunController = TextEditingController();
  TextEditingController ayController = TextEditingController();
  TextEditingController yilController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Çıkmak istiyor musun?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            SystemNavigator.pop();
                          },
                          child: const Text("Evet")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Hayır")),
                    ],
                  );
                }),
            style: IconButton.styleFrom(backgroundColor: Colors.blue.shade200),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        centerTitle: true,
        //title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 800) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 150),
                //color: Colors.red,
                child: HomeChild(
                  enlemController: enlemController,
                  rakimController: rakimController,
                  ruzgarHizi10mController: ruzgarHizi10mController,
                  minRhController: minRhController,
                  maxRhController: maxRhController,
                  minSicaklikController: minSicaklikController,
                  maxSicaklikController: maxSicaklikController,
                  gunlukGuneslenmeSuresiController: gunlukGuneslenmeSuresiController,
                  gunController: gunController,
                  ayController: ayController,
                  yilController: yilController,
                ),
              );
            } else {
              return HomeChild(
                enlemController: enlemController,
                rakimController: rakimController,
                ruzgarHizi10mController: ruzgarHizi10mController,
                minRhController: minRhController,
                maxRhController: maxRhController,
                minSicaklikController: minSicaklikController,
                maxSicaklikController: maxSicaklikController,
                gunlukGuneslenmeSuresiController: gunlukGuneslenmeSuresiController,
                gunController: gunController,
                ayController: ayController,
                yilController: yilController,
              );
            }
          },
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              naviguer(context: context, page: const OtuzGunHesaplama());
            },
            child: const Text("30 günlük hesaplama"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                int j = getJ(m: int.parse(ayController.text), d: int.parse(gunController.text), year: int.parse(yilController.text));
                double eto = calculateEt0(
                    enlem: double.parse(enlemController.text),
                    rakim: double.parse(rakimController.text),
                    ruzgarHizi10m: double.parse(ruzgarHizi10mController.text),
                    minRh: double.parse(minRhController.text),
                    maxRh: double.parse(maxRhController.text),
                    minT: double.parse(minSicaklikController.text),
                    maxT: double.parse(maxSicaklikController.text),
                    gunlukGuneslenmeSuresi: double.parse(gunlukGuneslenmeSuresiController.text),
                    j: j);
                await showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(child: Lottie.asset("assets/lottie/animated tree.json", width: 150)),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0, bottom: 35, left: 12, right: 12),
                              child: Text.rich(
                                TextSpan(style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w400), children: [
                                  const TextSpan(text: "Girilen verilere göre "),
                                  TextSpan(
                                    text: "${gunController.text} ${getMonthName(ayController.text)} ${yilController.text} ",
                                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.green),
                                  ),
                                  const TextSpan(text: "tarihi için referans toplam buharlaşma:")
                                ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: "ET\u2080:    ${eto.toStringAsFixed(5)} ",
                                ),
                                const TextSpan(text: "mm/gün", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.green))
                              ]),
                              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 25),
                              child: ElevatedButton(
                                  onPressed: () {
                                    pop(context);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                                  child: const Text("Kapat")),
                            )
                          ],
                        ),
                      );
                    });
                //log.log("rs: ${getRnl(tDew: 0, tmax: 298.3, tmin: 292.3, phi: -22.90.toRad(), j: getJ(m: m, d: d, year: 2023), n: n))}");
              }
            },
            //tooltip: 'Hesapla',
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: FittedBox(child: Text("Hesapla")),
            ),
          )
        ],
      ),
    );
  }

  String getMonthName(String text) {
    switch (int.parse(text)) {
      case 1:
        return "ocak";
      case 2:
        return "şubat";
      case 3:
        return "mart";
      case 4:
        return "nisan";
      case 5:
        return "mayıs";
      case 6:
        return "haziran";
      case 7:
        return "temuz";
      case 8:
        return "ağustos";
      case 9:
        return "eylül";
      case 10:
        return "ekim";
      case 11:
        return "kasım";
      case 12:
        return "aralık";
    }
    return "";
  }
}
