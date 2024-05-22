class GunModel {
  GunModel({
    required this.enlem,
    required this.rakim,
    required this.ruzgarHizi10,
    required this.minBagilNem,
    required this.maxBagilNem,
    required this.minSicaklik,
    required this.maxSicaklik,
    required this.gunlukGuneslenmeSuresi,
    required this.gun,
  });
  late final String enlem;
  late final String rakim;
  late final String ruzgarHizi10;
  late final String minBagilNem;
  late final String maxBagilNem;
  late final String minSicaklik;
  late final String maxSicaklik;
  late final String gunlukGuneslenmeSuresi;
  late final String gun;

  GunModel.fromJson(Map<String, dynamic> json) {
    enlem = json['enlem'];
    rakim = json['rakim'];
    ruzgarHizi10 = json['ruzgarHizi10'];
    minBagilNem = json['minBagilNem'];
    maxBagilNem = json['maxBagilNem'];
    minSicaklik = json['minSicaklik'];
    maxSicaklik = json['maxSicaklik'];
    gunlukGuneslenmeSuresi = json['gunlukGuneslenmeSuresi'];
    gun = json['gun'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['enlem'] = enlem;
    data['rakim'] = rakim;
    data['ruzgarHizi10'] = ruzgarHizi10;
    data['minBagilNem'] = minBagilNem;
    data['maxBagilNem'] = maxBagilNem;
    data['minSicaklik'] = minSicaklik;
    data['maxSicaklik'] = maxSicaklik;
    data['gunlukGuneslenmeSuresi'] = gunlukGuneslenmeSuresi;
    data['gun'] = gun;
    return data;
  }
}
