import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../countries/domain/entities/country.dart';
import '../repositories/favorites_repository.dart';

class AddToFavorites {
  final FavoritesRepository repository;

  AddToFavorites(this.repository);

  Future<Either<Failure, void>> call(Country country) async {
    return await repository.addToFavorites(country);
  }
}
