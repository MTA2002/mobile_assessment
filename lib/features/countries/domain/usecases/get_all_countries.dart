import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/country.dart';
import '../repositories/countries_repository.dart';

class GetAllCountries {
  final CountriesRepository repository;

  GetAllCountries(this.repository);

  Future<Either<Failure, List<Country>>> call() async {
    return await repository.getAllCountries();
  }
}
