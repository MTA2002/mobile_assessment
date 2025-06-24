import 'package:app/core/network/network_info.dart';
import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/country.dart';
import '../../domain/repositories/countries_repository.dart';
import '../datasources/countries_local_datasource.dart';
import '../datasources/countries_remote_datasource.dart';

class CountriesRepositoryImpl implements CountriesRepository {
  final CountriesRemoteDataSource remoteDataSource;
  final CountriesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  CountriesRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Country>>> getAllCountries() async {
    try {
      // Check internet connectivity
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        try {
          // Try to fetch from remote
          final remoteCountries = await remoteDataSource.getAllCountries();

          // Cache the results
          await localDataSource.cacheCountries(remoteCountries);

          return Right(remoteCountries);
        } catch (e) {
          // If remote fails but cache is valid, return cache
          final isCacheValid = await localDataSource.isCacheValid();
          if (isCacheValid) {
            final cachedCountries = await localDataSource.getCachedCountries();
            return Right(cachedCountries);
          }
          return Left(
              const ServerFailure('Failed to fetch countries from server'));
        }
      } else {
        // No internet, try cache
        try {
          final cachedCountries = await localDataSource.getCachedCountries();
          return Right(cachedCountries);
        } catch (e) {
          return Left(const CacheFailure(
              'No internet connection and no cached data available'));
        }
      }
    } catch (e) {
      return Left(const ServerFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> searchCountriesByName(
      String name) async {
    try {
      // For search, we'll prioritize fresh data if connected
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        try {
          final remoteCountries =
              await remoteDataSource.searchCountriesByName(name);
          return Right(remoteCountries);
        } catch (e) {
          // If remote search fails, try to search in cache
          return await _searchInCache(name);
        }
      } else {
        // No internet, search in cache
        return await _searchInCache(name);
      }
    } catch (e) {
      return Left(const ServerFailure('Failed to search countries'));
    }
  }

  @override
  Future<Either<Failure, Country>> getCountryByName(String name) async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        try {
          final country = await remoteDataSource.getCountryByName(name);
          return Right(country);
        } catch (e) {
          // If remote fails, try to find in cache
          return await _findCountryInCache(name);
        }
      } else {
        // No internet, search in cache
        return await _findCountryInCache(name);
      }
    } catch (e) {
      return Left(const ServerFailure('Failed to get country details'));
    }
  }

  @override
  Future<Either<Failure, List<Country>>> getCountriesByRegion(
      String region) async {
    try {
      final isConnected = await networkInfo.isConnected;

      if (isConnected) {
        try {
          final remoteCountries =
              await remoteDataSource.getCountriesByRegion(region);
          return Right(remoteCountries);
        } catch (e) {
          // If remote fails, try to filter cache by region
          return await _filterCacheByRegion(region);
        }
      } else {
        // No internet, filter cache by region
        return await _filterCacheByRegion(region);
      }
    } catch (e) {
      return Left(const ServerFailure('Failed to get countries by region'));
    }
  }

  // Helper method to search in cache
  Future<Either<Failure, List<Country>>> _searchInCache(String name) async {
    try {
      final cachedCountries = await localDataSource.getCachedCountries();
      final filteredCountries = cachedCountries
          .where((country) =>
              country.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
      return Right(filteredCountries);
    } catch (e) {
      return Left(const CacheFailure('Failed to search in cached data'));
    }
  }

  // Helper method to find specific country in cache
  Future<Either<Failure, Country>> _findCountryInCache(String name) async {
    try {
      final cachedCountries = await localDataSource.getCachedCountries();
      final country = cachedCountries.firstWhere(
        (country) => country.name.toLowerCase() == name.toLowerCase(),
        orElse: () => throw const NotFoundException(),
      );
      return Right(country);
    } catch (e) {
      if (e is NotFoundException) {
        return Left(const NotFoundFailure('Country not found'));
      }
      return Left(const CacheFailure('Failed to find country in cached data'));
    }
  }

  // Helper method to filter cache by region
  Future<Either<Failure, List<Country>>> _filterCacheByRegion(
      String region) async {
    try {
      final cachedCountries = await localDataSource.getCachedCountries();
      final filteredCountries = cachedCountries
          .where(
              (country) => country.region.toLowerCase() == region.toLowerCase())
          .toList();
      return Right(filteredCountries);
    } catch (e) {
      return Left(const CacheFailure('Failed to filter cached data by region'));
    }
  }
}
