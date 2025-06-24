import '../../../countries/domain/entities/country.dart';

class FavoriteCountry extends Country {
  final String id;
  final DateTime addedAt;

  const FavoriteCountry({
    required this.id,
    required this.addedAt,
    required super.name,
    required super.flag,
    required super.area,
    required super.region,
    required super.subregion,
    required super.population,
    required super.timezones,
  });

  // Create from Country entity
  factory FavoriteCountry.fromCountry(Country country) {
    return FavoriteCountry(
      id: country.name, // Using name as unique identifier
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

  // Convert to Country entity
  Country toCountry() {
    return Country(
      name: name,
      flag: flag,
      area: area,
      region: region,
      subregion: subregion,
      population: population,
      timezones: timezones,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteCountry && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  List<Object?> get props => super.props + [id, addedAt];
}
