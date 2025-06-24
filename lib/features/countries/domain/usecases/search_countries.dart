import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class SearchCountries {
  final CountriesRepository repository;

  SearchCountries(this.repository);

  Future<Either<Failure, List<Country>>> call(String searchTerm) async {
    if (searchTerm.isEmpty) {
      return await repository.getAllCountries();
    }
    return await repository.searchCountriesByName(searchTerm);
  }
}
