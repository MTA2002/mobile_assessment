import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/country_model.dart';

abstract class CountriesLocalDataSource {
  Future<List<CountryModel>> getCachedCountries();
  Future<void> cacheCountries(List<CountryModel> countries);
  Future<void> clearCache();
  Future<bool> isCacheValid();
}

class CountriesLocalDataSourceImpl implements CountriesLocalDataSource {
  final SharedPreferences sharedPreferences;

  static const String cachedCountriesKey = 'CACHED_COUNTRIES';
  static const String cacheTimestampKey = 'CACHE_TIMESTAMP';
  static const Duration cacheValidDuration =
      Duration(hours: 24); // Cache valid for 24 hours

  CountriesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CountryModel>> getCachedCountries() async {
    try {
      final jsonString = sharedPreferences.getString(cachedCountriesKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((countryJson) => CountryModel.fromJson(countryJson))
            .toList();
      } else {
        throw const CacheException();
      }
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheCountries(List<CountryModel> countries) async {
    try {
      final List<Map<String, dynamic>> jsonList =
          countries.map((country) => country.toJson()).toList();
      final jsonString = json.encode(jsonList);

      await sharedPreferences.setString(cachedCountriesKey, jsonString);
      await sharedPreferences.setInt(
        cacheTimestampKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(cachedCountriesKey);
      await sharedPreferences.remove(cacheTimestampKey);
    } catch (e) {
      throw const CacheException();
    }
  }

  @override
  Future<bool> isCacheValid() async {
    try {
      final timestamp = sharedPreferences.getInt(cacheTimestampKey);
      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime) < cacheValidDuration;
    } catch (e) {
      return false;
    }
  }
}
