import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_biaya_listrik/list_storage.dart';

class CalculatorState extends ChangeNotifier {
  String jam = '0';
  String watt = '0';
  String? selectedGolongan;
  String? selectedDaya;

  late double jamNum = double.parse(jam);
  late double wattNum = double.parse(watt);
  late int indexGolongan;
  late int indexDaya;
  double totalBiayaHarian = 0;
  double totalBiayaBulan = 0;
  double totalBiayaTahun = 0;

  ListStorage storage = ListStorage();

  late Map<String, List<String>> daya = {
    'Rumah Tangga': storage.dayaRumahTangga,
    'Bisnis': storage.dayaBisnis,
  };

  calculateElectricityBill() {
    if (indexGolongan == 0) {
      indexDaya = storage.dayaRumahTangga.indexOf(selectedDaya!);
    } else if (indexGolongan == 1) {
      indexDaya = storage.dayaBisnis.indexOf(selectedDaya!);
    }
    double totalWatt = (wattNum * jamNum);
    totalBiayaHarian =
        totalWatt / 1000 * storage.biayaKWH[indexGolongan][indexDaya];
    totalBiayaBulan = totalBiayaHarian * 30;
    totalBiayaTahun = totalBiayaBulan * 12;
    notifyListeners();
  }

  convertToIDR(number) {
    NumberFormat formatToIDR =
        NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);
    return formatToIDR.format(number);
  }

  bool validate() {
    if (watt == '0' ||
        jam == '0' ||
        selectedDaya!.isEmpty ||
        // ignore: unnecessary_null_comparison
        indexGolongan == null) {
      return false;
    }
    return true;
  }

  void onChangeGolongan(String? newValue) {
    selectedDaya = null;
    selectedGolongan = newValue!;
    indexGolongan = storage.golongan.indexOf(selectedGolongan!);
    notifyListeners();
  }
}
