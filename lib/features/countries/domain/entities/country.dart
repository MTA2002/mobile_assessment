import 'package:equatable/equatable.dart';

class Country extends Equatable {
  final String name;
  final String flag;
  final double area;
  final String region;
  final String subregion;
  final int population;
  final List<String> timezones;

  const Country({
    required this.name,
    required this.flag,
    required this.area,
    required this.region,
    required this.subregion,
    required this.population,
    required this.timezones,
  });

  @override
  List<Object?> get props => [
        name,
        flag,
        area,
        region,
        subregion,
        population,
        timezones,
      ];

  @override
  String toString() {
    return 'Country(name: $name, region: $region, population: $population)';
  }
}
