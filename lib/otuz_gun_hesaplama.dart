import 'dart:math';
//import 'dart:developer' as dev;
import 'package:bitirme_projesi/functions.dart';
import 'package:bitirme_projesi/gun_model.dart';
import 'package:bitirme_projesi/json_verileri.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OtuzGunHesaplama extends StatefulWidget {
  const OtuzGunHesaplama({super.key});

  @override
  State<OtuzGunHesaplama> createState() => _OtuzGunHesaplamaState();
}

class _OtuzGunHesaplamaState extends State<OtuzGunHesaplama> {
  ScrollController scrollController = ScrollController();
  bool isScrollingUp = false;
  bool isLineChart = true;
  List<GunModel> gunler = jsonVeriler.map((e) {
    return GunModel.fromJson(e);
  }).toList();
  List<double> etos = [];
  List<double> listEto = [];
  double toplam = 0;
  bool toplamCalculated = false;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      //log("adlistener called");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (scrollController.position.userScrollDirection == ScrollDirection.forward) {
          //  log("scrolling down");
          setState(() {
            isScrollingUp = false;
          });
        } else if (scrollController.position.userScrollDirection == ScrollDirection.reverse) {
          //  log("scrolling up");
          setState(() {
            isScrollingUp = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: !isScrollingUp
          ? AppBar(
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              title: const Text(
                "Ocak ayı için bitki su tüketimi",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              centerTitle: true,
            )
          : null,
      body: SafeArea(child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Padding(
            padding: constraints.maxWidth > 800 ? const EdgeInsets.symmetric(horizontal: 48.0) : EdgeInsets.zero,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton.filled(
                        onPressed: () {
                          if (isLineChart == true) {
                            setState(() {
                              isLineChart = false;
                              toplamCalculated = true;
                            });
                          }
                        },
                        style: IconButton.styleFrom(backgroundColor: !isLineChart ? Colors.orange : Colors.orange.shade100),
                        icon: const Icon(Icons.bar_chart_rounded)),
                    const SizedBox(
                      width: 20,
                    ),
                    IconButton.filled(
                        onPressed: () {
                          if (isLineChart == false) {
                            setState(() {
                              isLineChart = true;
                              toplamCalculated = true;
                            });
                          }
                        },
                        style: IconButton.styleFrom(backgroundColor: isLineChart ? Colors.orange : Colors.orange.shade100),
                        icon: const Icon(Icons.show_chart)),
                  ],
                ),
                isLineChart
                    ? MyCustomLineChart(
                        gunler: gunler,
                        etos: etos,
                      )
                    : MyCustomBarChart(gunler: gunler, etos: etos),
                const SizedBox(
                  height: 20,
                ),
                Text.rich(TextSpan(style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20), children: [
                  const TextSpan(
                    text: "Toplam ET\u2080: ",
                  ),
                  TextSpan(text: "$toplam mm/ay,", style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.green))
                ])),
                ListView.builder(
                  itemCount: gunler.length,
                  controller: scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 120),
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    GunModel gun = gunler[index];
                    String etoString = calculateEt0(
                            enlem: double.parse(gun.enlem),
                            rakim: double.parse(gun.rakim),
                            ruzgarHizi10m: double.parse(gun.ruzgarHizi10),
                            minRh: double.parse(gun.minBagilNem),
                            maxRh: double.parse(gun.maxBagilNem),
                            minT: double.parse(gun.minSicaklik),
                            maxT: double.parse(gun.maxSicaklik),
                            gunlukGuneslenmeSuresi: double.parse(gun.gunlukGuneslenmeSuresi),
                            j: int.parse(gun.gun))
                        .toStringAsFixed(4);
                    double eto = double.parse(etoString);
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      listEto.add(eto);
                      if (toplamCalculated == false) {
                        toplam = toplam + eto;
                      } else {}

                      if (index < 32) {
                        etos = listEto;
                      } else {
                        toplamCalculated = true;
                      }
                    });
                    return Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(offset: const Offset(-1.8, -1.8), color: Colors.blue.shade200, spreadRadius: 0.1, blurRadius: 1.8),
                            BoxShadow(offset: const Offset(0.2, 0.2), color: Colors.blue.shade200, spreadRadius: 0.1, blurRadius: 1.8),
                          ],
                          color: Colors.white),
                      child: LayoutBuilder(
                        builder: (BuildContext context, BoxConstraints constraints) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${gun.gun} ocak 2017",
                                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: Colors.red.shade300),
                              ),
                              Text(
                                "min T: ${gun.minSicaklik}",
                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text.rich(
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                  TextSpan(children: [
                                    const TextSpan(text: "ET\u2080:"),
                                    TextSpan(
                                        text: " ${eto.toStringAsFixed(4)} mm/gün",
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.blue))
                                  ]))
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      })),
    );
  }
}

class MyCustomLineChart extends StatelessWidget {
  final List<GunModel> gunler;
  final List<double> etos;
  const MyCustomLineChart({super.key, required this.gunler, required this.etos});

  @override
  Widget build(BuildContext context) {
    TextStyle axisTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.orange.shade700);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width * 1.5,
        height: MediaQuery.sizeOf(context).height * 0.56,
        child: etos.isNotEmpty
            ? Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, top: 8),
                      child: LineChart(
                        LineChartData(
                          lineBarsData: [
                            LineChartBarData(
                                isCurved: true,
                                barWidth: 4,
                                color: Colors.green,
                                spots: gunler.map((e) => FlSpot(double.parse(gunler[gunler.indexOf(e)].gun), etos[gunler.indexOf(e)])).toList())
                          ],
                          titlesData: FlTitlesData(
                              show: true,
                              rightTitles: const AxisTitles(
                                  drawBelowEverything: false, axisNameSize: 25, sideTitles: SideTitles(reservedSize: 50, showTitles: false)),
                              bottomTitles: AxisTitles(
                                sideTitles: const SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: bottomTitles,
                                  reservedSize: 25,
                                ),
                                axisNameWidget: Text(
                                  "Günler",
                                  style: axisTextStyle,
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  axisNameWidget: Text(
                                    "Toplam Buharlaşma (mm/gün)",
                                    style: axisTextStyle,
                                  ),
                                  sideTitles: const SideTitles(showTitles: true, reservedSize: 35)),
                              topTitles: const AxisTitles(drawBelowEverything: false, sideTitles: SideTitles(showTitles: false))),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}

class MyCustomBarChart extends StatelessWidget {
  final List<GunModel> gunler;
  final List<double> etos;
  const MyCustomBarChart({super.key, required this.gunler, required this.etos});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    bool isGreaterThan800 = width > 700;
    TextStyle axisTextStyle = TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.orange.shade700);
    return etos.isNotEmpty
        ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: SizedBox(
                width: isGreaterThan800 ? MediaQuery.sizeOf(context).width : MediaQuery.sizeOf(context).width * 1.4,
                height: MediaQuery.sizeOf(context).height * 0.68,
                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BarChart(
                          BarChartData(
                              titlesData: FlTitlesData(
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(
                                    showTitles: true,
                                  )),
                                  bottomTitles: AxisTitles(
                                    sideTitles: const SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: bottomTitles,
                                      reservedSize: 35,
                                    ),
                                    axisNameWidget: Column(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Günler",
                                            style: axisTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  leftTitles: AxisTitles(
                                      axisNameWidget: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          "Toplam Buharlaşma (mm/gün)",
                                          style: axisTextStyle,
                                        ),
                                      ),
                                      sideTitles: const SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: leftTitles)),
                                  topTitles: const AxisTitles(drawBelowEverything: false)),
                              gridData: const FlGridData(show: false),
                              rangeAnnotations: RangeAnnotations(verticalRangeAnnotations: [
                                VerticalRangeAnnotation(x1: 0, x2: 3),
                                VerticalRangeAnnotation(x1: 4, x2: 7),
                                VerticalRangeAnnotation(x1: 8, x2: 10),
                                VerticalRangeAnnotation(x1: 11, x2: 4),
                              ]),
                              extraLinesData: ExtraLinesData(horizontalLines: [HorizontalLine(y: 5, color: Colors.orange, strokeWidth: 2)]),
                              barGroups: gunler.map((e) {
                                int r1 = Random().nextInt(255);
                                int r2 = Random().nextInt(255);
                                int r3 = Random().nextInt(255);
                                Color color = Color.fromARGB(255, r1, r2, r3);
                                return BarChartGroupData(x: int.parse(e.gun), barRods: [
                                  BarChartRodData(
                                      toY: //5,
                                          etos[gunler.indexOf(e)],
                                      fromY: 0,
                                      width: 8.5,
                                      color: color),
                                  // BarChartRodData(toY: double.parse(e.minSicaklik), fromY: 0, width: 6.5, color: color),
                                ]);
                              }).toList(),
                              barTouchData: BarTouchData(
                                  touchCallback: (e, a) async {},
                                  touchTooltipData:
                                      BarTouchTooltipData(tooltipBgColor: Colors.white, tooltipBorder: const BorderSide(color: Colors.green)))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : const Center(
            child: CircularProgressIndicator(),
          );
  }
}

Widget bottomTitles(double value, TitleMeta meta) {
  final Widget text = Text(
    "${value.toInt()}",
    style: const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    //fitInside: SideTitleFitInsideData.fromTitleMeta(meta), //margin top
    child: text,
  );
}

Widget getbottomTitlesBarChart(double value, TitleMeta meta) {
  final Widget text = Text(
    "${value.toInt()}",
    style: const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    //fitInside: SideTitleFitInsideData.fromTitleMeta(meta), //margin top
    child: text,
  );
}

Widget leftTitles(double value, TitleMeta meta) {
  final Widget text = Text(
    value.toStringAsFixed(2),
    style: const TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.w700,
      fontSize: 12,
    ),
  );
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 1,
    //fitInside: SideTitleFitInsideData.fromTitleMeta(meta), //margin top
    child: text,
  );
}
