import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../countries/domain/entities/country.dart';
import '../entities/favorite_country.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteCountry>>> getFavorites();
  Future<Either<Failure, void>> addToFavorites(Country country);
  Future<Either<Failure, void>> removeFromFavorites(String countryId);
  Future<Either<Failure, bool>> isFavorite(String countryId);
  Future<Either<Failure, void>> clearFavorites();
}
