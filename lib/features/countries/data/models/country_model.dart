import 'dart:convert';

import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({
    required super.name,
    required super.flag,
    required super.area,
    required super.region,
    required super.subregion,
    required super.population,
    required super.timezones,
  });

  /// Factory constructor to create a CountryModel from JSON
  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']?['common'] ?? '',
      flag: json['flags']?['png'] ?? json['flags']?['svg'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      population: json['population'] ?? 0,
      timezones: List<String>.from(json['timezones'] ?? []),
    );
  }

  /// Convert CountryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flag},
      'area': area,
      'region': region,
      'subregion': subregion,
      'population': population,
      'timezones': timezones,
    };
  }

  /// Factory constructor to create from JSON string
  factory CountryModel.fromJsonString(String jsonString) {
    final json = jsonDecode(jsonString);
    return CountryModel.fromJson(json);
  }

  /// Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }

  /// Create a copy with updated values
  CountryModel copyWith({
    String? name,
    String? flag,
    double? area,
    String? region,
    String? subregion,
    int? population,
    List<String>? timezones,
  }) {
    return CountryModel(
      name: name ?? this.name,
      flag: flag ?? this.flag,
      area: area ?? this.area,
      region: region ?? this.region,
      subregion: subregion ?? this.subregion,
      population: population ?? this.population,
      timezones: timezones ?? this.timezones,
    );
  }

  /// Convert domain Country entity to CountryModel
  factory CountryModel.fromEntity(Country country) {
    return CountryModel(
      name: country.name,
      flag: country.flag,
      area: country.area,
      region: country.region,
      subregion: country.subregion,
      population: country.population,
      timezones: country.timezones,
    );
  }
}
