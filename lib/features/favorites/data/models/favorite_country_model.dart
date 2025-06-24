import '../../domain/entities/favorite_country.dart';
import '../../../countries/domain/entities/country.dart';

class FavoriteCountryModel extends FavoriteCountry {
  const FavoriteCountryModel({
    required super.id,
    required super.addedAt,
    required super.name,
    required super.flag,
    required super.area,
    required super.region,
    required super.subregion,
    required super.population,
    required super.timezones,
  });

  factory FavoriteCountryModel.fromJson(Map<String, dynamic> json) {
    return FavoriteCountryModel(
      id: json['id'] as String,
      addedAt: DateTime.parse(json['addedAt'] as String),
      name: json['name'] as String,
      flag: json['flag'] as String,
      area: (json['area'] as num).toDouble(),
      region: json['region'] as String,
      subregion: json['subregion'] as String,
      population: json['population'] as int,
      timezones: List<String>.from(json['timezones'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'addedAt': addedAt.toIso8601String(),
      'name': name,
      'flag': flag,
      'area': area,
      'region': region,
      'subregion': subregion,
      'population': population,
      'timezones': timezones,
    };
  }

  factory FavoriteCountryModel.fromEntity(FavoriteCountry favorite) {
    return FavoriteCountryModel(
      id: favorite.id,
      addedAt: favorite.addedAt,
      name: favorite.name,
      flag: favorite.flag,
      area: favorite.area,
      region: favorite.region,
      subregion: favorite.subregion,
      population: favorite.population,
      timezones: favorite.timezones,
    );
  }

  factory FavoriteCountryModel.fromCountry(Country country) {
    return FavoriteCountryModel(
      id: country.name,
      addedAt: DateTime.now(),
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
