import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/country.dart';

abstract class CountriesRepository {
  /// Fetches all independent countries from the API
  Future<Either<Failure, List<Country>>> getAllCountries();

  /// Searches for countries by name
  Future<Either<Failure, List<Country>>> searchCountriesByName(String name);

  /// Gets a specific country by its name
  Future<Either<Failure, Country>> getCountryByName(String name);

  /// Gets countries by region
  Future<Either<Failure, List<Country>>> getCountriesByRegion(String region);
}
