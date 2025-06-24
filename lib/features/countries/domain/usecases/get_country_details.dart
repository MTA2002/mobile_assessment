import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountryDetails {
  final CountriesRepository repository;

  GetCountryDetails(this.repository);

  Future<Either<Failure, Country>> call(String countryName) async {
    return await repository.getCountryByName(countryName);
  }
}
