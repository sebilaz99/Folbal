import 'package:dinte_albastru/data/repository.dart';
import 'package:dinte_albastru/my_logger.dart';
import 'package:dinte_albastru/text_component.dart';
import 'package:dinte_albastru/utils.dart';
import 'package:dinte_albastru/validations.dart';
import 'package:flutter/cupertino.dart';

import '../model/registration_request.dart';

class RegistrationViewModel extends ChangeNotifier {
  String _selectedPosition = Utils().emptyString;

  String get selectedPosition => _selectedPosition;

  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;

  TextComponent _fullName = TextComponent(
    text: Utils().emptyString,
    error: null,
  );

  TextComponent get fullName => _fullName;

  TextComponent _password = TextComponent(
    text: Utils().emptyString,
    error: null,
  );

  List<RegistrationRequest> _requests = List.empty(growable: true);

  List<RegistrationRequest> get requests => _requests;

  TextComponent get password => _password;

  RegistrationViewModel();

  Future<void> setPosition(String value) async {
    _selectedPosition = value;
    notifyListeners();
  }

  Future<void> setIsAdmin(bool value) async {
    _isAdmin = value;
    notifyListeners();
  }

  Future<void> setFullName(String value) async {
    _fullName.text = value;
    _fullName.error = Validations.validateFullName(value);
    notifyListeners();
  }

  Future<void> setNameError(String value) async {
    _fullName.error = value;
    notifyListeners();
  }

  Future<void> setPassword(String value) async {
    _password.text = value;
    _password.error = Validations.validatePassword(value);
    notifyListeners();
  }

  Future<void> createRegistrationRequest(RegistrationRequest request) async {
    await Repository().createRegistrationRequest(request);
    notifyListeners();
  }

  Future<List<RegistrationRequestEntity>> fetchRegistrationRequests() async {
    List<RegistrationRequestEntity> requests =
        await Repository().getAllRequests();
    _requests = requests.map((request) => request.toModel).toList();
    notifyListeners();
    logger.i("RegVM:: ${requests.length}");
    return requests;
  }

  Future<void> deleteRegistrationRequest(String name) async {
    try {
      await Repository().deleteRegistrationEntity(name);
      logger.d("RegVM:: $name's request deleted");
      notifyListeners();
    } catch (e) {
      logger.e("RegVM:: $e");
    }
  }
}
