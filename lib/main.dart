import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CalculatorState(),
      child: MaterialApp(
        title: 'Kalkulator Biaya Listrik',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class CalculatorState extends ChangeNotifier {
  String jam = '0';
  String watt = '0';
  String? selectedGolongan;
  String? selectedDaya;

  late double jamNum = double.parse(jam);
  late double wattNum = double.parse(watt);
  late int indexGolongan;
  late int indexDaya;
  late double biayaKWH;
  double totalBiayaHarian = 0;
  double totalBiayaBulan = 0;
  double totalBiayaTahun = 0;

  List<String> golongan = ['Rumah Tangga', 'Bisnis'];
  List<String> dayaRumahTangga = [
    'R1/TR (0 - 450 VA) (Subsidi)',
    'R1/TR (451 - 900 VA) (Subsidi)',
    'R1/TR (451 - 900 VA) (Non-Subsidi)',
    'R1/TR (901 - 1300 VA)',
    'R1/TR (1301 - 2200 VA)',
    'R2/TR (2201 - 5500 VA)',
    'R3/TR (>5500 VA)'
  ];
  List<String> dayaBisnis = [
    'B1/TR (0 - 450 VA) (Subsidi)',
    'B1/TR (451 - 900 VA) (Subsidi)',
    'B1/TR (451 - 900 VA) (Non-Subsidi)',
    'B1/TR (901 - 1300 VA)',
    'B2/TR (5501 VA - 200 kVA)',
    'B3/TM (>200 kVA)'
  ];
  //final List<num> biayaKWHRumahTangga = [169, 274, 1352, 1444.70];
  //final List<num> biayaKWHBisnis = [254, 420, 966, 1100, 1444.70, 1114.74];

  late Map<String, List<String>> daya = {
    'Rumah Tangga': dayaRumahTangga,
    'Bisnis': dayaBisnis,
  };

  calculateElectricityBill() {
    if (indexGolongan == 0) {
      indexDaya = dayaRumahTangga.indexOf(selectedDaya!);
      switch (indexDaya) {
        case 0:
          biayaKWH = 169;
          break;
        case 1:
          biayaKWH = 274;
          break;
        case 2:
          biayaKWH = 1352;
          break;
        default:
          biayaKWH = 1444.70;
          break;
      }
    } else if (indexGolongan == 1) {
      indexDaya = dayaBisnis.indexOf(selectedDaya!);
      switch (indexDaya) {
        case 0:
          biayaKWH = 254;
          break;
        case 1:
          biayaKWH = 420;
          break;
        case 2:
          biayaKWH = 966;
          break;
        case 3:
          biayaKWH = 1100;
          break;
        case 5:
          biayaKWH = 1114.74;
          break;
        default:
          biayaKWH = 1444.70;
          break;
      }
    }
    double totalWatt = (wattNum * jamNum);
    totalBiayaHarian = totalWatt / 1000 * biayaKWH;
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
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<CalculatorState>();
    return Scaffold(
        appBar: AppBar(title: Text('Kalkulator Biaya Listrik')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input ini kosong, mohon diisi';
                    } else if (value == '0') {
                      return 'Input tidak boleh berupa 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.bolt),
                    labelText: 'Watt Yang Digunakan',
                    suffix: Text('Watt'),
                  ),
                  onChanged: (text) {
                    appState.watt = text;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Input ini kosong, mohon diisi';
                    }
                    int checkJam = int.parse(value);
                    if (checkJam > 24) {
                      return 'Input jam melebihi 24 jam';
                    } else if (value == '0') {
                      return 'Input tidak boleh berupa 0';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    icon: Icon(Icons.schedule),
                    labelText: 'Waktu Penggunaan Listrik/Hari',
                    suffix: Text('Jam'),
                  ),
                  onChanged: (text) {
                    appState.jam = text;
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton<String>(
                    hint: Text('Golongan'),
                    isExpanded: true,
                    value: appState.selectedGolongan,
                    items: appState.golongan
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        appState.selectedDaya = null;
                        appState.selectedGolongan = newValue!;
                        appState.indexGolongan = appState.golongan
                            .indexOf(appState.selectedGolongan!);
                      });
                    }),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: DropdownButton<String>(
                    hint: Text('Daya'),
                    isExpanded: true,
                    value: appState.selectedDaya,
                    items: appState.daya[appState.selectedGolongan]
                        ?.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        appState.selectedDaya = newValue;
                      });
                    }),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: ElevatedButton(
                  child: Text('Hitung!'),
                  onPressed: () {
                    bool validation = appState.validate();
                    if (validation == false) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Mohon isi seluruh field yang ada')));
                    } else if (validation == true) {
                      appState.calculateElectricityBill();
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                child: Row(children: [
                  Text('Biaya Listrik/Hari:     '),
                  Text(appState.convertToIDR(appState.totalBiayaHarian)),
                ]),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: Row(children: [
                  Text('Biaya Listrik/Bulan:   '),
                  Text(appState.convertToIDR(appState.totalBiayaBulan)),
                ]),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 60),
                child: Row(children: [
                  Text('Biaya Listrik/Tahun:  '),
                  Text(appState.convertToIDR(appState.totalBiayaTahun)),
                ]),
              ),
            ],
          ),
        ));
  }
}

/*
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme:
          ThemeData(primarySwatch: Colors.blue, brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ThemeMode.dark,
      home: const DropdownListDemo(),
    );
  }
}

class DropdownListDemo extends StatefulWidget {
  const DropdownListDemo({Key? key}) : super(key: key);

  @override
  State<DropdownListDemo> createState() => _DropdownListDemoState();
}

class _DropdownListDemoState extends State<DropdownListDemo> {
  final dynamic items = ['Item 1', 'Item 2', 'Item 3'];
  String dropdownValue = 'Item 1';

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: DropdownButton<String>(
              isExpanded: true,
              value: dropdownValue,
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              }),
        ),
      ),
    );
  }
}
*/
