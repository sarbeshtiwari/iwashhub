import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:iwash/screen/screen2/franchise_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Franchise extends StatefulWidget {
  const Franchise({super.key});
  static String id = 'Franchise';

  @override
  State<Franchise> createState() => _FranchiseState();
}

class _FranchiseState extends State<Franchise> {
  String fileContent = '';
  String fileContent1 = '';

  @override
  void initState() {
    super.initState();
    fetchTextFile();
  }

  Future<void> fetchTextFile() async {
    try {
      final String response =
          await rootBundle.loadString('assets/franchise.txt');
      setState(() {
        fileContent = response;
      });
      final String response1 =
          await rootBundle.loadString('assets/franchise1.txt');
      setState(() {
        fileContent1 = response1;
      });
    } catch (e) {
      //print('Error fetching text file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Store Partner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/images/fra.png'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Are you constantly plagued by investment concerns day and night?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(fileContent),
              const SizedBox(
                height: 10,
              ),
              DataTable(
                columnSpacing: 15,
                columns: const [
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('ECO')),
                  DataColumn(label: Text('ELITE')),
                ],
                rows: const [
                  DataRow(cells: [
                    DataCell(Text('Target')),
                    DataCell(Text('Domestic/Corporate')),
                    DataCell(Text('ECO + Commercial ( Hospitals & Hotels )')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Area Sq.Ft.')),
                    DataCell(Text('500-700')),
                    DataCell(Text('1000-1500')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Model')),
                    DataCell(Text('FOCO')),
                    DataCell(Text('FOCO')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('CAFÉ')),
                    DataCell(Text('YES')),
                    DataCell(Text('YES')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Service Offering')),
                    DataCell(Text('Full')),
                    DataCell(Text('Full')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Principle Breakeven')),
                    DataCell(Text('Within 15 Month')),
                    DataCell(Text('Within 15 Month')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('ROI')),
                    DataCell(Text('UPTO 60%-70%')),
                    DataCell(Text('UPTO 50%')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Est. Revenue')),
                    DataCell(Text('Upto 3 Lac')),
                    DataCell(Text('Upto 8 Lac')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('O.C')),
                    DataCell(Text('Upto 1 Lac')),
                    DataCell(Text('Upto 2.5 Lac')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Est. N.P')),
                    DataCell(Text('Upto 2 Lac')),
                    DataCell(Text('Upto 5.5 Lac')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Support')),
                    DataCell(Text('Turnkey')),
                    DataCell(Text('Turnkey')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Project Cost')),
                    DataCell(Text('20 Lac')),
                    DataCell(Text('32 Lac')),
                  ])
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Why iWash Hub?",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  fileContent1,
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  launchUrl(Uri.parse(
                      "https://iwashhub.com/index.php/franchise-form/"));
                  //Navigator.pushNamed(context, FranchiseScreen.id);
                },
                child: const Text('Raise a Franchise Query'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
