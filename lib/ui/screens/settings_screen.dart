import 'package:flutter/material.dart';
import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/utils.dart';
import 'package:dinte_albastru/view_model/settings_view_model.dart';
import 'package:provider/provider.dart';

import '../../network_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with ChangeNotifier {
  final TextEditingController textName = TextEditingController();
  final Helper helper = Helper();
  ValueNotifier<String> selectedItpDate = ValueNotifier(Utils().emptyString);

  @override
  void initState() {
    super.initState();
    getAgeFromPrefsAndSetInApp(Utils().ageKey);
    Future.microtask(() {
      final viewModel = context.read<SettingsViewModel>();
      viewModel.getThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    final networkStatus = Provider.of<NetworkProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings Screen"),
        ),
        body: Stack(children: [
          Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20.0, vertical: 10.0), // Custom padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      child: TextField(
                          controller: textName,
                          decoration: const InputDecoration(
                              hintText: "Enter your age", labelText: "Age"))),
                  const SizedBox(height: 30),
                  OutlinedButton(
                      onPressed: () {
                        openDatePicker(context);
                      },
                      child: Row(children: [
                        ValueListenableBuilder<String?>(
                          valueListenable: selectedItpDate,
                          builder: (context, value, child) {
                            return Text(
                              value != null
                                  ? 'Data urmatorului ITP: $selectedItpDate'
                                  : 'Nicio data selectata',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            );
                          },
                        ),
                        const Icon(Icons.calendar_today_outlined)
                      ])),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: () {
                        Repository()
                            .saveToPrefsWithoutNavi(
                                Utils().ageKey, textName.text)
                            .then((onValue) {
                          String message = onValue
                              ? "The age has been saved"
                              : "An error has occurred";
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                              duration: const Duration(seconds: 4)));
                        });
                      },
                      child: const Text("Save")),
                ],
              )),
          Positioned(
              bottom: 0, // Positioned at the bottom of the screen
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Network Status",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(networkStatus.status)
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Light/Dark Theme",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Consumer<SettingsViewModel>(
                          builder: (context, viewModel, child) {
                        if (!viewModel.isInitialized) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Switch(
                            value: viewModel.isDarkMode,
                            onChanged: (value) {
                              viewModel.setThemeMode(value);
                            });
                      })
                    ],
                  )
                ]),
              ))
        ]));
  }

  Future<void> getAgeFromPrefsAndSetInApp(String key) async {
    final age = await helper.getString(key);
    textName.text = age ?? Utils().emptyString;
    setState(() {});
  }

  Future<void> openDatePicker(BuildContext context) async {
    String stringDate = Utils().emptyString;
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2030));

    if (pickedDate != null) {
      stringDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      selectedItpDate.value = stringDate;
      Helper().setPreference(Utils().nextItpKey, stringDate);
    }
  }
}
