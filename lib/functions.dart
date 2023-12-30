import 'dart:math';

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

double calculateETo({
  required double ortalamaSicaklik,
  required double uz,
  required double rakim,
  double albedo = 0.23,
  required double enlemDerecesi,
  required double birYilIcerisindekiGunlerinSirasi,
  required double gercekGuneslenmeSuresi,
  required double tmin,
  required double tmax,
  required double ciglenmeNoktasiSicakligi,
  required double gunBatimiSaatAcisi,
  required double gunesKirimi,
}) {
  double delta = getDelta(sicaklik: ortalamaSicaklik);
  double u2 = getU2(uz: uz, z: rakim);
  double y = getyGamma(z: rakim);
  double ra = getRa(ws: gunBatimiSaatAcisi, phi: enlemDerecesi, delt: gunesKirimi, j: birYilIcerisindekiGunlerinSirasi);
  double rs = getRs(phi: enlemDerecesi, j: birYilIcerisindekiGunlerinSirasi, n: gercekGuneslenmeSuresi);
  double rn = getRn(
      albedo: albedo,
      enlemDerecesi: enlemDerecesi,
      j: birYilIcerisindekiGunlerinSirasi,
      n: gercekGuneslenmeSuresi,
      tDew: ciglenmeNoktasiSicakligi,
      tmax: tmax,
      tmin: tmin,
      rs: rs,
      ra: ra,
      z: rakim);
  double g = 0;
  double temp = 0;
  double es = 0;
  double ea = 0;
  double eto = (0.408 * delta * (rn - g) + y * (900 / (temp + 273)) * u2 * (es - ea)) / (delta + y * (1 + 0.34 * u2));

  return eto;
}

double getRn({
  double albedo = 0.23,
  required double enlemDerecesi,
  required double j,
  required double n,
  required double tDew,
  required double tmax,
  required double tmin,
  required double rs,
  required double ra,
  required double z,
}) {
  double rns = getRns(albedo: albedo, phi: enlemDerecesi, j: j, n: n);
  double rnl = getRnl(tDew: tDew, tmax: tmax, tmin: tmin, rs: rs, ra: ra, z: z);
  double rn = rns - rnl;
  return rn;
}

double getRnl({
  required double tDew,
  required double tmax,
  required double tmin,
  required double rs,
  required double ra,
  required double z,
}) {
  double ea = getEaDewPoint(tDew: tDew);
  double rso = getRso(ra: ra, z: z);
  double rnl = boltzmannConstant * ((pow(tmax, 4) + pow(tmin, 4)) / 2) * (0.34 - 0.14 * sqrt(ea)) * (1.35 * (rs / rso) - 0.35);
  return rnl;
}

double getRso({
  required double ra,
  required double z,
}) {
  double rso = (as + bs) * ra;
  return rso;
}

double getEaDewPoint({required double tDew}) {
  double ea = 0.6108 * exp((17.27 * tDew) / (tDew + 237.3));
  return ea;
}

double getRns({
  double albedo = 0.23,
  required double phi,
  required double j,
  required double n,
}) {
  double rs = getRs(phi: phi, j: j, n: n);
  double rns = (1 - albedo) / rs;
  return rns;
}

double getRs({
  required double phi,
  required double j,
  required double n,
}) {
  double delt = 0.409 * sin(((2 * pi * j) / 365) - 1.39);
  double ws = acos(-tan(phi) * tan(delt));
  double buyukN = (24 / pi) * ws;
  double ra = getRa(ws: ws, phi: phi, delt: delt, j: j);
  double rs = (as + bs * (n / buyukN)) * ra;
  return rs;
}

double getRa({required double ws, required double phi, required double delt, required double j}) {
  double dr = 1 + 0.033 * cos((2 * pi * j) / 365);
  double ra = 24 * (60 / pi) * gsc * dr * ((ws * sin(phi) * sin(delt) + cos(phi)) * (cos(delt) * cos(ws)));
  return ra;
}

double getyGamma({required double z}) {
  double pressure = 101.3 * pow((293 - 0.0065 * z) / 293, 5.26);
  double y = 0.000665 * pressure;
  return y;
}

double getU2({required double uz, required double z}) {
  double u2 = uz * (4.87 / log(67.8 * z - 5.42));
  return u2;
}

double getDelta({required double sicaklik}) {
  double delta = (4098 * (0.6108 * exp((17.27 * sicaklik) / (sicaklik + 237.3)))) / (pow((sicaklik + 237.3), 2));
  return delta;
}
