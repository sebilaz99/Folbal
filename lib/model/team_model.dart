import 'dart:ui';

import 'package:dinte_albastru/identifiable.dart';
import 'package:dinte_albastru/model/player_model.dart';

import '../utils.dart';

class Team {
  final String name;
  final String logo;
  final List<Player>? players;
  final List<Color> colors;

  Team({
    required this.name,
    required this.logo,
    required this.players,
    required this.colors,
  });
}

class TeamEntity implements Identifiable {
  final String name;
  final String logo;
  final List<PlayerEntity>? players;
  final List<Color> colors;
  @override
  int? id;

  TeamEntity({
    this.id,
    required this.name,
    required this.logo,
    required this.players,
    required this.colors,
  });

  Map<String, dynamic> toJson() => {
    'team_id': id,
    'team_name': name,
    'team_logo': logo,
    'team_players': players?.map((p) => p.toJson()).toList(),
    'team_colors': colors.map((c) => c.value).toList(),
  };

  factory TeamEntity.fromJson(Map<String, dynamic> json) => TeamEntity(
    id: json['team_id'] as int?,
    name: json['team_name'] ?? Utils().emptyString,
    logo: json['team_logo'] ?? Utils().emptyString,
    players:
        (json['players'] as List<dynamic>?)
            ?.map((item) => PlayerEntity.fromJson(item))
            .toList() ??
        [],
    colors:
        (json['team_colors'] as List<dynamic>?)
            ?.map((c) => Color(c as int))
            .toList() ??
        [],
  );
}

extension TeamEntityToModel on TeamEntity {
  Team get toModel => Team(
    name: name,
    logo: logo,
    players: players?.map((p) => p.toModel).toList(),
    colors: colors,
  );
}
