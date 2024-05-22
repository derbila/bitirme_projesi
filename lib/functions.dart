import 'dart:math';

import 'package:flutter/material.dart';

final RegExp numberRegExp = RegExp(r'^-?(\d+|\d*\.\d+)$');
String? validateTextField(String? value) {
  if (value != null) {
    return value.isEmpty
        ? 'Bir değer giriniz lütfen'
        : numberRegExp.hasMatch(value)
            ? null
            : 'Bir sayı giriniz lütfen';
  } else {
    return 'Bir değer giriniz lütfen';
  }
}

double gsc = 0.0820;
double as = 0.25;
double bs = 0.5;
double boltzmannConstant = 4.903 * pow(10, -9);

double calculateEt0({
  required double enlem,
  required double rakim,
  required double ruzgarHizi10m,
  required double minRh,
  required double maxRh,
  required double minT,
  required double maxT,
  required double gunlukGuneslenmeSuresi,
  required int j,
}) {
  double ortalamaSicaklik = (minT + maxT) / 2;
  double phi = (enlem * pi) / 180;
  double delta = getDelta(ortalamaSicaklik: ortalamaSicaklik);
  double g = 0;
  double rs = getRs(phi: phi, j: j, n: gunlukGuneslenmeSuresi);
  double ra = getRa(phi: phi, j: j);
  double atmosferBasinc = getPressure(rakim);
  double rn =
      getRn(enlemDerecesi: phi, j: j, n: gunlukGuneslenmeSuresi, tmax: maxT, tmin: minT, maxRh: maxRh, minRh: minRh, rs: rs, ra: ra, z: rakim);
  double y = getPsychrometricConstantPressure(atmosferBasinc: atmosferBasinc);
  double u2 = getU2(uz: ruzgarHizi10m, z: rakim);
  double es = getEs(tmax: maxT, tmin: minT);
  double ea = getea(tmin: minT, tmax: maxT, maxRh: maxRh, minRh: minRh);
  double eto = (0.408 * delta * (rn - g) + (y * 900 * u2 * (es - ea)) / (ortalamaSicaklik + 273)) / (delta + y * (1 + 0.34 * u2));

  return eto;
}

double gete0Tmax({required tmax}) {
  return 0.6108 * pow(2.7183, 17.27 * tmax / (tmax + 237.3));
}

double gete0Tmin({required tmin}) {
  return 0.6108 * pow(2.7183, 17.27 * tmin / (tmin + 237.3));
}

double getEs({required double tmax, required double tmin}) {
  double e0Tmax = gete0Tmax(tmax: tmax);
  double e0Tmin = gete0Tmin(tmin: tmin);
  double es = (e0Tmax + e0Tmin) / 2;
  return es;
}

double getDelta({required double ortalamaSicaklik}) {
  double delta = (4098 * (0.6108 * exp((17.27 * ortalamaSicaklik) / (ortalamaSicaklik + 237.3)))) / (pow((ortalamaSicaklik + 237.3), 2));
  return delta;
}

double getea({
  required double tmin,
  required double tmax,
  required double maxRh,
  required double minRh,
}) {
  double e0tamax = gete0Tmax(tmax: tmax);
  double e0tamin = gete0Tmin(tmin: tmin);
  double ea = ((e0tamin * maxRh / 100) + (e0tamax * minRh / 100)) / 2;
  return ea;
}

double getdr({required int j}) {
  return 1 + 0.033 * cos((2 * pi * j) / 365);
}

double getdelt({required int j}) {
  double delt = 0.409 * sin(((2 * pi * j) / 365 - 1.39));
  return delt;
}

double getWs({required double phi, required int j}) {
  double delt = getdelt(j: j);
  double x = (1 - pow(tan(phi), 2) * pow(tan(delt), 2)).toDouble();
  if (x <= 0) {
    x = 0.00001;
  }

  double ws = (pi / 2) - atan((-tan(phi) * tan(delt)) / pow(x, 0.5));
  return ws;
}

double getRa({
  required double phi,
  required int j,
}) {
  double ws = getWs(phi: phi, j: j);
  double delt = getdelt(j: j);
  double dr = getdr(j: j);
  double ra = 24 * (60 / pi) * gsc * dr * (ws * sin(phi) * sin(delt) + cos(phi) * cos(delt) * sin(ws));
  return ra;
}

double getRs({
  required double phi,
  required int j,
  required double n,
}) {
  double ws = getWs(phi: phi, j: j);
  double buyukN = (24 / pi) * ws;
  double ra = getRa(phi: phi, j: j);
  double rs = (as + bs * (n / buyukN)) * ra;
  return rs;
}

double getRso({
  required double z,
  required double ra,
}) {
  double rso = (0.75 + (2 * pow(10, -5) * z)) * ra;
  return rso;
}

double getRns({
  double albedo = 0.23,
  required double phi,
  required int j,
  required double n,
}) {
  double rs = getRs(phi: phi, j: j, n: n);
  double rns = (1 - albedo) * rs;
  return rns;
}

int getJ({required int m, required int d, required int year}) {
  bool isLeapYear = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  int j = (((275 * m / 9) - 30 + d) - 2).toInt();

  if (m < 3) {
    j = j + 2;
  }
  if (isLeapYear && m > 2) {
    j = j + 1;
  }
  if (m == 1 && d == 1) {
    j = 1;
  }
  return j;
}

double getPsychrometricConstantPressure({required double atmosferBasinc}) {
  double y = 0.000665 * atmosferBasinc;
  return y;
}

double getU2({required double uz, required double z}) {
  double u2 = uz * 4.87 / log(67.8 * 10 - 5.42);
  return u2;
}

double getRn({
  double albedo = 0.23,
  required double enlemDerecesi,
  required int j,
  required double n,
  required double tmax,
  required double tmin,
  required double maxRh,
  required double minRh,
  required double rs,
  required double ra,
  required double z,
}) {
  double rns = getRns(albedo: albedo, phi: enlemDerecesi, j: j, n: n);
  double rnl = getRnl(
    tmax: tmax,
    tmin: tmin,
    maxRh: maxRh,
    minRh: minRh,
    phi: enlemDerecesi,
    j: j,
    n: n,
    z: z,
  );
  double rn = rns - rnl;
  return rn;
}

double getRnl(
    {required double tmax,
    required double tmin,
    required double phi,
    required double maxRh,
    required double minRh,
    required int j,
    required double n,
    required double z,
    bool eaWithTmin = true}) {
  double ra = getRa(phi: phi, j: j);
  double rs = getRs(phi: phi, j: j, n: n);
  double ea = getea(tmin: tmin, tmax: tmax, maxRh: maxRh, minRh: minRh);
  double rso = getRso(ra: ra, z: z);
  double rnl = boltzmannConstant * ((pow(tmax + 273.16, 4) + pow(tmin + 273.16, 4)) / 2) * (0.34 - 0.14 * sqrt(ea)) * (1.35 * (rs / rso) - 0.35);
  return rnl;
}

extension ToRad on num {
  double toRad() => (this * pi) / 180;
}

extension ToDegre on num {
  double toDegre() => (this * 180) / pi;
}

double getPressure(double z) {
  double p = 101.3 * pow(((293 - 0.0065 * z) / 293), 5.26);
  return p;
}

void naviguer({required BuildContext context, required Widget page}) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}

void pop(BuildContext context) {
  Navigator.of(context).pop();
}
