import '../identifiable.dart';
import '../utils.dart';

class Player {
  final String fullName;
  final String position;
  final bool isCaptain;

  Player({
    required this.fullName,
    required this.position,
    required this.isCaptain,
  });
}

class PlayerEntity implements Identifiable {
  final String fullName;
  final String position;
  final bool isCaptain;
  @override
  int? id;

  PlayerEntity({
    this.id,
    required this.fullName,
    required this.position,
    required this.isCaptain,
  });

  Map<String, dynamic> toJson() => {
    'player_id': id,
    'player_fullName': fullName,
    'player_position': position,
    'player_isCaptain': isCaptain,
  };

  factory PlayerEntity.fromJson(Map<String, dynamic> json) => PlayerEntity(
    id: json['player_id'] as int?,
    fullName: json['player_fullName'] ?? Utils().emptyString,
    position: json['player_position'] ?? Utils().emptyString,
    isCaptain: json['player_isCaptain'] ?? false,
  );
}

extension PlayerEntityToModel on PlayerEntity {
  Player get toModel {
    return Player(fullName: fullName, position: position, isCaptain: isCaptain);
  }
}
