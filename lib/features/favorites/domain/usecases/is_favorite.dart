import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../repositories/favorites_repository.dart';

class IsFavorite {
  final FavoritesRepository repository;

  IsFavorite(this.repository);

  Future<Either<Failure, bool>> call(String countryId) async {
    return await repository.isFavorite(countryId);
  }
}
