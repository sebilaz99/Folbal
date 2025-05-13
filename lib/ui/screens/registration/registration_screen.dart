import 'package:dinte_albastru/helper.dart';
import 'package:dinte_albastru/model/registration_request.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/utils.dart';
import 'package:dinte_albastru/view_model/registration_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../validations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreen();
}

class _RegistrationScreen extends State<RegistrationScreen>
    with ChangeNotifier {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController password = TextEditingController();
  ValueNotifier<String> buttonText = ValueNotifier("Register now");
  bool isButtonClicked = false;
  final formKey = GlobalKey<FormState>();
  final List<String> _positions = [
    "",
    "ST",
    "LF",
    "RF",
    "CM",
    "RB",
    "LB",
    "CB",
    "GK",
  ];
  final List<String> _isAdminValues = ["No", "Yes"];
  final fullNameNode = FocusNode();
  final passwordNode = FocusNode();
  final positionNode = FocusNode();

  @override
  void dispose() {
    password.dispose();
    fullName.dispose();
    fullNameNode.dispose();
    passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Register",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/drawables/tunnel.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Semantics(
                  label: "User's full name input field",
                  hint: "",

                  child: TextFormField(
                    onChanged: (value) {
                      viewModel.setFullName(value);
                    },
                    style: TextStyle(color: Colors.white),
                    controller: fullName,
                    obscureText: false,
                    decoration: InputDecoration(
                      errorText: Validations.validateFullName(fullName.text),
                      hintText: "Enter your name",
                      labelText: "Full name",
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  onChanged: (value) {
                    viewModel.setPassword(value);
                  },
                  style: TextStyle(color: Colors.white),
                  controller: password,
                  obscureText: false,
                  decoration: InputDecoration(
                    errorText: Validations.validatePassword(password.text),
                    hintText: "Set a password",
                    labelText: "Password",
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 40,
                  children: [
                    Text(
                      "Preferred position",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    DropdownButton<String>(
                      iconEnabledColor: Colors.white,
                      dropdownColor: Colors.transparent,
                      items:
                          _positions.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          viewModel.setPosition(newValue);
                        }
                      },
                      value: viewModel.selectedPosition,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  spacing: 40,
                  children: [
                    Text(
                      "Are you admin?",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    DropdownButton<String>(
                      dropdownColor: Colors.transparent,
                      iconEnabledColor: Colors.white,
                      items:
                          _isAdminValues.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          bool value = newValue == "No" ? false : true;
                          viewModel.setIsAdmin(value);
                        }
                      },
                      value: viewModel.isAdmin ? "Yes" : "No",
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0, // Positioned at the bottom of the screen
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: OutlinedButton(
                onPressed: () {
                  if (!isInvalidOutput(
                    setErrorMessage(
                      viewModel.fullName.error,
                      viewModel.selectedPosition,
                      viewModel.password.error,
                    ),
                  )) {
                    viewModel.createRegistrationRequest(
                      RegistrationRequest(
                        fullName: fullName.text,
                        password: password.text,
                        position: viewModel.selectedPosition,
                        isAdmin: viewModel.isAdmin,
                      ),
                    );
                    logger.e("REGISTRATION CREATED");
                    setState(() {
                      buttonText.value = "Registration request sent";
                    });
                  } else {
                    Helper().showToast(
                      context,
                      setErrorMessage(
                        viewModel.fullName.error,
                        viewModel.selectedPosition,
                        viewModel.password.error,
                      ),
                    );
                  }
                },
                child: Text(
                  buttonText.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool isInvalidOutput(String? errorMessage) {
    return errorMessage != Utils().emptyString;
  }

  String setErrorMessage(
    String? nameError,
    String position,
    String? passwordError,
  ) {
    String errorMessage = Utils().emptyString;
    if (nameError != null) {
      errorMessage = nameError;
    } else if (passwordError != null) {
      errorMessage = passwordError;
    } else if (position == Utils().emptyString) {
      errorMessage = "Position must not be empty";
    }
    return errorMessage;
  }

  void disableButton() {}
}
