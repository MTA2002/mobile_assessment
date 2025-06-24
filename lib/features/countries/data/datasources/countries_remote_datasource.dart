import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/country_model.dart';

abstract class CountriesRemoteDataSource {
  Future<List<CountryModel>> getAllCountries();
  Future<List<CountryModel>> searchCountriesByName(String name);
  Future<CountryModel> getCountryByName(String name);
  Future<List<CountryModel>> getCountriesByRegion(String region);
}

class CountriesRemoteDataSourceImpl implements CountriesRemoteDataSource {
  final ApiConsumer apiConsumer;

  CountriesRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<List<CountryModel>> getAllCountries() async {
    try {
      final response = await apiConsumer.get(
        ApiConstants.allCountries,
        queryParameters: {
          ApiConstants.fieldsParam: ApiConstants.detailFields,
        },
      );

      if (response is List) {
        return response
            .map((country) => CountryModel.fromJson(country))
            .where((country) => country.name.isNotEmpty)
            .toList();
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<List<CountryModel>> searchCountriesByName(String name) async {
    try {
      final response = await apiConsumer.get(
        '${ApiConstants.countryByName}/$name',
        queryParameters: {
          ApiConstants.fieldsParam: ApiConstants.detailFields,
        },
      );

      if (response is List) {
        return response
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<CountryModel> getCountryByName(String name) async {
    try {
      final response = await apiConsumer.get(
        '${ApiConstants.countryByName}/$name',
        queryParameters: {
          ApiConstants.fieldsParam: ApiConstants.detailFields,
        },
      );

      if (response is List && response.isNotEmpty) {
        return CountryModel.fromJson(response.first);
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }

  @override
  Future<List<CountryModel>> getCountriesByRegion(String region) async {
    try {
      final response = await apiConsumer.get(
        '${ApiConstants.countryByRegion}/$region',
        queryParameters: {
          ApiConstants.fieldsParam: ApiConstants.detailFields,
        },
      );

      if (response is List) {
        return response
            .map((country) => CountryModel.fromJson(country))
            .toList();
      } else {
        throw const ServerException();
      }
    } catch (e) {
      throw const ServerException();
    }
  }
}
