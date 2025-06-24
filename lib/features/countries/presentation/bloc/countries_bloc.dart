import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_all_countries.dart';
import '../../domain/usecases/get_country_details.dart';
import '../../domain/usecases/search_countries.dart';
import 'countries_event.dart';
import 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  final GetAllCountries getAllCountries;
  final SearchCountries searchCountries;
  final GetCountryDetails getCountryDetails;

  CountriesBloc({
    required this.getAllCountries,
    required this.searchCountries,
    required this.getCountryDetails,
  }) : super(CountriesInitial()) {
    on<LoadCountriesEvent>(_onLoadCountries);
    on<SearchCountriesEvent>(_onSearchCountries);
    on<GetCountryDetailsEvent>(_onGetCountryDetails);
    on<RefreshCountriesEvent>(_onRefreshCountries);
  }

  Future<void> _onLoadCountries(
    LoadCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountriesLoading());

    final result = await getAllCountries();

    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (countries) {
        if (countries.isEmpty) {
          emit(const CountriesEmpty('No countries found'));
        } else {
          emit(CountriesLoaded(countries));
        }
      },
    );
  }

  Future<void> _onSearchCountries(
    SearchCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    if (event.searchTerm.isEmpty) {
      add(LoadCountriesEvent());
      return;
    }

    emit(CountriesSearching());

    final result = await searchCountries(event.searchTerm);

    result.fold(
      (failure) => emit(CountriesError(failure.message)),
      (countries) {
        if (countries.isEmpty) {
          emit(const CountriesEmpty('No countries found for your search'));
        } else {
          emit(CountriesSearchLoaded(countries, event.searchTerm));
        }
      },
    );
  }

  Future<void> _onGetCountryDetails(
    GetCountryDetailsEvent event,
    Emitter<CountriesState> emit,
  ) async {
    emit(CountryDetailsLoading());

    final result = await getCountryDetails(event.countryName);

    result.fold(
      (failure) => emit(CountryDetailsError(failure.message)),
      (country) => emit(CountryDetailsLoaded(country)),
    );
  }

  Future<void> _onRefreshCountries(
    RefreshCountriesEvent event,
    Emitter<CountriesState> emit,
  ) async {
    // Force refresh by loading countries again
    add(LoadCountriesEvent());
  }
}
