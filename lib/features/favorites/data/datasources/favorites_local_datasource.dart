import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/favorite_country_model.dart';

abstract class FavoritesLocalDataSource {
  Future<List<FavoriteCountryModel>> getFavorites();
  Future<void> addToFavorites(FavoriteCountryModel favorite);
  Future<void> removeFromFavorites(String countryId);
  Future<bool> isFavorite(String countryId);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  static const String favoritesKey = 'CACHED_FAVORITES';

  final SharedPreferences sharedPreferences;

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FavoriteCountryModel>> getFavorites() async {
    try {
      final jsonString = sharedPreferences.getString(favoritesKey);
      if (jsonString != null) {
        final jsonList = json.decode(jsonString) as List;
        return jsonList
            .map((jsonMap) => FavoriteCountryModel.fromJson(jsonMap))
            .toList();
      }
      return [];
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> addToFavorites(FavoriteCountryModel favorite) async {
    try {
      final favorites = await getFavorites();

      // Check if already exists
      if (!favorites.any((f) => f.id == favorite.id)) {
        favorites.add(favorite);
        await _saveFavorites(favorites);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> removeFromFavorites(String countryId) async {
    try {
      final favorites = await getFavorites();
      favorites.removeWhere((favorite) => favorite.id == countryId);
      await _saveFavorites(favorites);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<bool> isFavorite(String countryId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((favorite) => favorite.id == countryId);
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> clearFavorites() async {
    try {
      await sharedPreferences.remove(favoritesKey);
    } catch (e) {
      throw CacheException();
    }
  }

  Future<void> _saveFavorites(List<FavoriteCountryModel> favorites) async {
    final jsonList = favorites.map((favorite) => favorite.toJson()).toList();
    await sharedPreferences.setString(favoritesKey, json.encode(jsonList));
  }
}
