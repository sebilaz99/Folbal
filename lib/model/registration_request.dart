import 'package:dinte_albastru/identifiable.dart';

import '../utils.dart';

class RegistrationRequest {
  final String fullName;
  final String password;
  final String position;
  final bool isAdmin;

  RegistrationRequest({
    required this.fullName,
    required this.password,
    required this.position,
    required this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'password': password,
      'position': position,
      'isAdmin': isAdmin,
    };
  }
}

class RegistrationRequestEntity implements Identifiable {
  final String fullName;
  final String password;
  final String position;
  final bool isAdmin;
  @override
  int? id;

  RegistrationRequestEntity({
    this.id,
    required this.fullName,
    required this.password,
    required this.position,
    required this.isAdmin,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'password': password,
    'position': position,
    'isAdmin': isAdmin,
  };

  factory RegistrationRequestEntity.fromJson(Map<String, dynamic> json) =>
      RegistrationRequestEntity(
        id: json['id:'] as int?,
        fullName: json['fullName'] ?? Utils().emptyString,
        password: json['password'] ?? Utils().emptyString,
        position: json['position'] ?? Utils().emptyString,
        isAdmin: json['isAdmin'] ?? false,
      );
}

extension RegistrationRequestEntityToModel on RegistrationRequestEntity {
  RegistrationRequest get toModel {
    return RegistrationRequest(
      fullName: fullName,
      password: password,
      position: position,
      isAdmin: isAdmin,
    );
  }
}
