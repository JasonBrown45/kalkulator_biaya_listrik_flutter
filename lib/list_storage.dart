class ListStorage {
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

  final biayaKWH = [
    [169, 274, 1352, 1444.70, 1444.70, 1444.70, 1444.70],
    [254, 420, 966, 1100, 1444.70, 1114.74]
  ];
}
