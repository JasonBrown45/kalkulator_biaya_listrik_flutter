import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculation.dart';

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
                        appState.onChangeGolongan(newValue);
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
