import 'package:equatable/equatable.dart';

import '../../domain/entities/country.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object> get props => [];
}

class CountriesInitial extends CountriesState {}

class CountriesLoading extends CountriesState {}

class CountriesLoaded extends CountriesState {
  final List<Country> countries;

  const CountriesLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountriesError extends CountriesState {
  final String message;

  const CountriesError(this.message);

  @override
  List<Object> get props => [message];
}

class CountryDetailsLoading extends CountriesState {}

class CountryDetailsLoaded extends CountriesState {
  final Country country;

  const CountryDetailsLoaded(this.country);

  @override
  List<Object> get props => [country];
}

class CountryDetailsError extends CountriesState {
  final String message;

  const CountryDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class CountriesSearching extends CountriesState {}

class CountriesSearchLoaded extends CountriesState {
  final List<Country> countries;
  final String searchTerm;

  const CountriesSearchLoaded(this.countries, this.searchTerm);

  @override
  List<Object> get props => [countries, searchTerm];
}

class CountriesEmpty extends CountriesState {
  final String message;

  const CountriesEmpty(this.message);

  @override
  List<Object> get props => [message];
}
