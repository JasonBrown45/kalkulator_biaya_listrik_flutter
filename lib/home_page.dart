import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'calculation.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CalculatorState>(
      builder: (context, calculator, child) {
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
                        calculator.watt = text;
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
                        calculator.jam = text;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: DropdownButton<String>(
                        hint: Text('Golongan'),
                        isExpanded: true,
                        value: calculator.selectedGolongan,
                        items: calculator.storage.golongan
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          calculator.onChangeGolongan(newValue);
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: DropdownButton<String>(
                        hint: Text('Daya'),
                        isExpanded: true,
                        value: calculator.selectedDaya,
                        items: calculator.daya[calculator.selectedGolongan]
                            ?.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          calculator.onChangedDaya(newValue!);
                        }),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      child: Text('Hitung!'),
                      onPressed: () {
                        bool validation = calculator.validate();
                        if (validation == false) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Mohon isi seluruh field yang ada')));
                        } else if (validation == true) {
                          calculator.calculateElectricityBill();
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 40, 20, 20),
                    child: Row(children: [
                      Text('Biaya Listrik/Hari:     '),
                      Text(
                          calculator.convertToIDR(calculator.totalBiayaHarian)),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: Row(children: [
                      Text('Biaya Listrik/Bulan:   '),
                      Text(calculator.convertToIDR(calculator.totalBiayaBulan)),
                    ]),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 60),
                    child: Row(children: [
                      Text('Biaya Listrik/Tahun:  '),
                      Text(calculator.convertToIDR(calculator.totalBiayaTahun)),
                    ]),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
