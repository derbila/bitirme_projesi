import 'dart:developer';

import 'package:bitirme_projesi/functions.dart';
import 'package:bitirme_projesi/result_page.dart';
import 'package:flutter/material.dart';
import 'home_child.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double width = 0;
  TextEditingController deltaController = TextEditingController();
  TextEditingController rnController = TextEditingController();
  TextEditingController gController = TextEditingController();
  TextEditingController cnController = TextEditingController();
  TextEditingController u2Controller = TextEditingController();
  TextEditingController esController = TextEditingController();
  TextEditingController eaController = TextEditingController();
  TextEditingController tController = TextEditingController();
  TextEditingController cdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            if (constraints.maxWidth > 800) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  width = constraints.maxWidth;
                });
              });

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 150),
                color: Colors.white,
                child: HomeChild(
                    deltaController: deltaController,
                    rnController: rnController,
                    gController: gController,
                    cnController: cnController,
                    u2Controller: u2Controller,
                    esController: esController,
                    eaController: eaController,
                    tController: tController,
                    cdController: cdController),
              );
            } else {
              return HomeChild(
                  deltaController: deltaController,
                  rnController: rnController,
                  gController: gController,
                  cnController: cnController,
                  u2Controller: u2Controller,
                  esController: esController,
                  eaController: eaController,
                  tController: tController,
                  cdController: cdController);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ResultPage(eto: 0)));
            log("ETo: 0");
          }
        },
        tooltip: 'Hesapla',
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: FittedBox(child: Text("Hesapla")),
        ),
      ),
    );
  }
}
