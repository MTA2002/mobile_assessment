import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/favorites_repository.dart';

class RemoveFromFavorites {
  final FavoritesRepository repository;

  RemoveFromFavorites(this.repository);

  Future<Either<Failure, void>> call(String countryId) async {
    return await repository.removeFromFavorites(countryId);
  }
}
