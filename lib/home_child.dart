import 'package:bitirme_projesi/functions.dart';
import 'package:flutter/material.dart';

import 'one_text_field_widget.dart';

class HomeChild extends StatelessWidget {
  final TextEditingController deltaController;
  final TextEditingController rnController;
  final TextEditingController gController;
  final TextEditingController cnController;
  final TextEditingController u2Controller;
  final TextEditingController esController;
  final TextEditingController eaController;
  final TextEditingController tController;
  final TextEditingController cdController;
  const HomeChild({
    super.key,
    required this.deltaController,
    required this.rnController,
    required this.gController,
    required this.cnController,
    required this.u2Controller,
    required this.esController,
    required this.eaController,
    required this.tController,
    required this.cdController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(bottom: 25, top: 10),
            child: Text(
              "Lütfen ET\u2080'u hesaplamak için gerekli olan aşağıdaki değerleri giriniz.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
          ),
          OneTextFieldWidget(
            controller: deltaController,
            validator: validateTextField,
            labelText: 'Δ: doygun buhar basıncı-sıcaklık eğrisinin eğimi',
          ),
          OneTextFieldWidget(
            controller: rnController,
            validator: validateTextField,
            labelText: 'R\u2099: bitki yüzeyi için hesaplanan net radyasyon',
          ),
          OneTextFieldWidget(
            controller: gController,
            validator: validateTextField,
            labelText: 'G: Toprak ısı akısı(MJ m\u207B\u00B2g\u207B\u00B9)',
          ),
          OneTextFieldWidget(
            controller: cnController,
            validator: validateTextField,
            labelText: 'C\u2099: Referans bitki tipi ve hesaplamanın yapıldığı zaman dilimi için sabit pay katsayısı',
          ),
          OneTextFieldWidget(
              controller: u2Controller,
              validator: validateTextField,
              labelText: "U\u2082: Günlük ortalama rüzgar hızı, 2.0 m yükseklikte ölçülmüş(ms\u207B\u00B9)"),
          OneTextFieldWidget(
              controller: esController,
              validator: validateTextField,
              labelText: "eₛ: Doygun buhar basıncı, 1.5 ile 2.5 m arasında yükseklik için hesaplanmış(KPa)"),
          OneTextFieldWidget(
              controller: eaController,
              validator: validateTextField,
              labelText: "eₐ: Gerçek buhar basıncı, 1.5 ile 2.5 m arasında yükseklik için hesaplanmış(KPa)"),
          OneTextFieldWidget(
              controller: tController,
              validator: validateTextField,
              labelText: "T: Günlük ortalama hava sıcaklığı, 1.5 ile 2.5 m arasında yükseklikte hesaplanmış"),
          OneTextFieldWidget(
              controller: cdController,
              validator: validateTextField,
              labelText:
                  "Cd: Referans bitki tipi ve hesaplamanın yapıldığı zaman dilimi için sabit payda katsayısı, (kısa boylu bitki ve günlük hesaplama için C\u2099=0.34)"),
        ],
      ),
    );
  }
}
