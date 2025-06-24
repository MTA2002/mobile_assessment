import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/countries/data/datasources/countries_local_datasource.dart';
import '../../features/countries/data/datasources/countries_remote_datasource.dart';
import '../../features/countries/data/repositories/countries_repository_impl.dart';
import '../../features/countries/domain/repositories/countries_repository.dart';
import '../../features/countries/domain/usecases/get_all_countries.dart';
import '../../features/countries/domain/usecases/get_country_details.dart';
import '../../features/countries/domain/usecases/search_countries.dart';
import '../../features/countries/presentation/bloc/countries_bloc.dart';
import '../api/api_consumer.dart';
import '../api/dio_consumer.dart';
import '../network/network_info.dart';
import '../theme/theme_cubit.dart';
import '../../features/favorites/data/datasources/favorites_local_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/favorites/domain/usecases/add_to_favorites.dart';
import '../../features/favorites/domain/usecases/get_favorites.dart';
import '../../features/favorites/domain/usecases/is_favorite.dart';
import '../../features/favorites/domain/usecases/remove_from_favorites.dart';
import '../../features/favorites/presentation/bloc/favorites_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Countries
  // Bloc
  sl.registerFactory(
    () => CountriesBloc(
      getAllCountries: sl(),
      searchCountries: sl(),
      getCountryDetails: sl(),
    ),
  );

  //! Core - Theme
  sl.registerLazySingleton(() => ThemeCubit());

  //! Features - Favorites
  // Bloc
  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      addToFavorites: sl(),
      removeFromFavorites: sl(),
      isFavorite: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddToFavorites(sl()));
  sl.registerLazySingleton(() => RemoveFromFavorites(sl()));
  sl.registerLazySingleton(() => IsFavorite(sl()));

  // Repository
  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<FavoritesLocalDataSource>(
    () => FavoritesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetAllCountries(sl()));
  sl.registerLazySingleton(() => SearchCountries(sl()));
  sl.registerLazySingleton(() => GetCountryDetails(sl()));

  // Repository
  sl.registerLazySingleton<CountriesRepository>(
    () => CountriesRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<CountriesRemoteDataSource>(
    () => CountriesRemoteDataSourceImpl(apiConsumer: sl()),
  );

  sl.registerLazySingleton<CountriesLocalDataSource>(
    () => CountriesLocalDataSourceImpl(sharedPreferences: sl()),
  );

  //! Core
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
}
