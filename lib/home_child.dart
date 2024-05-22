import 'package:bitirme_projesi/functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

import 'one_text_field_widget.dart';

class HomeChild extends StatefulWidget {
  final TextEditingController enlemController;
  final TextEditingController rakimController;
  final TextEditingController ruzgarHizi10mController;
  final TextEditingController minRhController;
  final TextEditingController maxRhController;
  final TextEditingController minSicaklikController;
  final TextEditingController maxSicaklikController;
  final TextEditingController gunlukGuneslenmeSuresiController;
  final TextEditingController gunController;
  final TextEditingController ayController;
  final TextEditingController yilController;
  const HomeChild({
    super.key,
    required this.enlemController,
    required this.rakimController,
    required this.ruzgarHizi10mController,
    required this.minRhController,
    required this.maxRhController,
    required this.minSicaklikController,
    required this.maxSicaklikController,
    required this.gunlukGuneslenmeSuresiController,
    required this.gunController,
    required this.ayController,
    required this.yilController,
  });

  @override
  State<HomeChild> createState() => _HomeChildState();
}

class _HomeChildState extends State<HomeChild> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String j = "";
  String gun = "";
  String ay = "";
  String yil = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 150),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Flexible(child: Lottie.asset("assets/lottie/watering tree.json", width: 150)),
              Flexible(child: Lottie.asset("assets/lottie/coconut tree.json", width: 150)),
            ],
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 25, top: 10),
            child: Text(
              "Referans buharlaşmayı (ET\u2080) hesaplamak için, lütfen aşağıdaki verileri giriniz.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),

          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        "Tarihi giriniz: ",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.99,
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ///   GÜN
                              Flexible(
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.30,
                                  height: 64,
                                  child: TextFormField(
                                    style: Theme.of(context).textTheme.titleLarge,
                                    textInputAction: TextInputAction.next,
                                    controller: widget.gunController,
                                    onChanged: (value) {
                                      if (value.length == 2) {
                                        if (value != "" || value.trim() != "" || value != " ") {
                                          setState(() {
                                            gun = value;
                                          });
                                          // FocusScope.of(context).nextFocus();
                                        }
                                      }
                                    },
                                    validator: (val) {
                                      if (val == null || val == "") {
                                        return "Lütfen bir değer giriniz.";
                                      }
                                      if (int.parse(val) <= 0 || int.parse(val) > 31) {
                                        return "Lütfen 1 ile 31 arasında bir değer giriniz.";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(hintText: "gün", border: OutlineInputBorder()),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ),

                              ///   AY
                              Flexible(
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.30,
                                  height: 64,
                                  child: TextFormField(
                                    style: Theme.of(context).textTheme.titleLarge,
                                    textInputAction: TextInputAction.next,
                                    controller: widget.ayController,
                                    onChanged: (value) {
                                      if (value.length == 2) {
                                        if (value != "" || value.trim() != "" || value != " ") {
                                          setState(() {
                                            ay = value;
                                          });
                                          // FocusScope.of(context).nextFocus();
                                        }
                                      }
                                    },
                                    validator: (val) {
                                      if (val == null || val == "" || val == " ") {
                                        return "Lütfen bir değer giriniz.";
                                      }
                                      if (val.length >= 2) {
                                        if (int.parse(val) <= 0 || int.parse(val) > 12) {
                                          return "Lütfen 1 ile 12 arasında bir değer giriniz.";
                                        }
                                        return null;
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(hintText: "ay", border: OutlineInputBorder()),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [LengthLimitingTextInputFormatter(2), FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ),

                              ///   YIL
                              Flexible(
                                child: SizedBox(
                                  width: constraints.maxWidth * 0.4,
                                  height: 64,
                                  child: TextFormField(
                                    style: Theme.of(context).textTheme.titleLarge,
                                    textInputAction: TextInputAction.next,
                                    controller: widget.yilController,
                                    onChanged: (value) {
                                      if (value.length == 4) {
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            j = "${getJ(m: int.parse(widget.ayController.text), d: int.parse(widget.gunController.text), year: int.parse(widget.yilController.text))}";
                                          });
                                          FocusScope.of(context).nextFocus();
                                        }
                                      }
                                    },
                                    validator: (val) {
                                      if (val == null || val == "") {
                                        return "Lütfen bir değer giriniz.";
                                      }
                                      if (val.length >= 4) {
                                        if (int.parse(val) < 1900 || int.parse(val) > DateTime.now().year) {
                                          return "Lütfen 1900 ile 2024 arasında bir değer giriniz.";
                                        }
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(hintText: "yıl", border: OutlineInputBorder()),
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [LengthLimitingTextInputFormatter(4), FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 18.0, bottom: 18),
                      child: Text(
                        "Yılın gün sayısı (j): $j",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: Column(
                children: [
                  OneTextFieldWidget(
                    controller: widget.enlemController,
                    validator: validateTextField,
                    inputAction: TextInputAction.next,
                    labelText: 'Enlem: Ölçüm yapılan yerin enlemi (°)',
                  ),
                  OneTextFieldWidget(
                    controller: widget.rakimController,
                    validator: validateTextField,
                    inputAction: TextInputAction.next,
                    labelText: 'z: Ölçüm yapılan yerin rakımı (m)',
                  ),
                  OneTextFieldWidget(
                    controller: widget.ruzgarHizi10mController,
                    validator: validateTextField,
                    inputAction: TextInputAction.next,
                    labelText: 'u\u2081\u2080: 10 m yükseklikteki rüzgar hızı (m/s)',
                  ),
                  OneTextFieldWidget(
                    controller: widget.minRhController,
                    validator: validateTextField,
                    inputAction: TextInputAction.next,
                    labelText: 'rh\u2098\u1d62\u2099: En düşük bağıl nem (%)',
                  ),
                  OneTextFieldWidget(
                      controller: widget.maxRhController,
                      validator: validateTextField,
                      inputAction: TextInputAction.next,
                      labelText: "rh\u2098\u2090\u2093: En yüksek bağıl nem (%)"),
                  OneTextFieldWidget(
                      controller: widget.minSicaklikController,
                      validator: validateTextField,
                      inputAction: TextInputAction.next,
                      labelText: "T\u2098\u1d62\u2099: En düşük sıcaklık (°C)"),
                  OneTextFieldWidget(
                      controller: widget.maxSicaklikController,
                      //inputAction: TextInputAction.next,
                      validator: validateTextField,
                      inputAction: TextInputAction.next,
                      labelText: "T\u2098\u2090\u2093: En yüksek sıcaklık (°C)"),
                  OneTextFieldWidget(
                      controller: widget.gunlukGuneslenmeSuresiController,
                      validator: validateTextField,
                      inputAction: TextInputAction.done,
                      labelText: "n: Günlük güneşlenme süresi (saat)"),
                ],
              ),
            ),
          ),
          // OneTextFieldWidget(controller: widget.atmosferBasincController, validator: validateTextField, labelText: "P: Atmosfer basıcı"),
        ],
      ),
    );
  }
}
