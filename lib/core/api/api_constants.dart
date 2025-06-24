class ApiConstants {
  static const String baseUrl = 'https://restcountries.com/v3.1/';

  // Endpoints
  static const String allCountries = 'all';
  static const String countryByName = 'name';
  static const String countryByCode = 'alpha';
  static const String countryByRegion = 'region';
  static const String countryBySubregion = 'subregion';

  // Query Parameters
  static const String fieldsParam = 'fields';

  // Common field sets - REST Countries API v3.1 requires fields parameter for /all endpoint
  static const String basicFields = 'name,flags,population,region,capital';
  static const String detailFields =
      'name,flags,population,region,subregion,capital,area,timezones';
}
