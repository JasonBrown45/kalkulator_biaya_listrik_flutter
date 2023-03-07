import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  final List<String> golongan = ['Rumah Tangga', 'Bisnis'];
  final List<String> dayaRumahTangga = [
    'R1/TR (0 - 450 VA) (Subsidi)',
    'R1/TR (451 - 900 VA) (Subsidi)',
    'R1/TR (451 - 900 VA) (Non-Subsidi)',
    'R1/TR (901 - 1300 VA)',
    'R1/TR (1301 - 2200 VA)',
    'R2/TR (2201 - 5500 VA)',
    'R3/TR (>5500 VA)'
  ];
  final List<String> dayaBisnis = [
    'B1/TR (0 - 450 VA) (Subsidi)',
    'B1/TR (451 - 900 VA) (Subsidi)',
    'B1/TR (451 - 900 VA) (Non-Subsidi)',
    'B1/TR (901 - 1300 VA)',
    'B2/TR (5501 VA - 200 kVA)',
    'B3/TM (>200 kVA)'
  ];
  static const biayaKWH = [
    [169, 274, 1352, 1444.70, 1444.70, 1444.70, 1444.70],
    [254, 420, 966, 1100, 1444.70, 1114.74]
  ];

  late Map<String, List<String>> daya = {
    'Rumah Tangga': dayaRumahTangga,
    'Bisnis': dayaBisnis,
  };

  calculateElectricityBill() {
    if (indexGolongan == 0) {
      indexDaya = dayaRumahTangga.indexOf(selectedDaya!);
    } else if (indexGolongan == 1) {
      indexDaya = dayaBisnis.indexOf(selectedDaya!);
    }
    double totalWatt = (wattNum * jamNum);
    totalBiayaHarian = totalWatt / 1000 * biayaKWH[indexGolongan][indexDaya];
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
    indexGolongan = golongan.indexOf(selectedGolongan!);
    notifyListeners();
  }
}
