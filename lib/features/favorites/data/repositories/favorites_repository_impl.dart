import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../../countries/domain/entities/country.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';
import '../models/favorite_country_model.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource localDataSource;

  FavoritesRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<FavoriteCountry>>> getFavorites() async {
    try {
      final favorites = await localDataSource.getFavorites();
      return Right(favorites);
    } on CacheException {
      return Left(CacheFailure('Failed to load favorites from cache'));
    } catch (e) {
      return Left(UnexpectedFailure(
          'Unexpected error occurred while loading favorites'));
    }
  }

  @override
  Future<Either<Failure, void>> addToFavorites(Country country) async {
    try {
      final favorite = FavoriteCountryModel.fromCountry(country);
      await localDataSource.addToFavorites(favorite);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to add country to favorites'));
    } catch (e) {
      return Left(UnexpectedFailure(
          'Unexpected error occurred while adding to favorites'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromFavorites(String countryId) async {
    try {
      await localDataSource.removeFromFavorites(countryId);
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to remove country from favorites'));
    } catch (e) {
      return Left(UnexpectedFailure(
          'Unexpected error occurred while removing from favorites'));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite(String countryId) async {
    try {
      final isFav = await localDataSource.isFavorite(countryId);
      return Right(isFav);
    } on CacheException {
      return Left(CacheFailure('Failed to check favorite status'));
    } catch (e) {
      return Left(UnexpectedFailure(
          'Unexpected error occurred while checking favorite status'));
    }
  }

  @override
  Future<Either<Failure, void>> clearFavorites() async {
    try {
      await localDataSource.clearFavorites();
      return const Right(null);
    } on CacheException {
      return Left(CacheFailure('Failed to clear favorites'));
    } catch (e) {
      return Left(UnexpectedFailure(
          'Unexpected error occurred while clearing favorites'));
    }
  }
}
