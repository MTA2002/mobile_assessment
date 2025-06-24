import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetCountriesByRegion {
  final CountriesRepository repository;

  GetCountriesByRegion(this.repository);

  Future<Either<Failure, List<Country>>> call(String region) async {
    return await repository.getCountriesByRegion(region);
  }
}
