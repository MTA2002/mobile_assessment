import 'package:equatable/equatable.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object> get props => [];
}

class LoadCountriesEvent extends CountriesEvent {}

class SearchCountriesEvent extends CountriesEvent {
  final String searchTerm;

  const SearchCountriesEvent(this.searchTerm);

  @override
  List<Object> get props => [searchTerm];
}

class GetCountryDetailsEvent extends CountriesEvent {
  final String countryName;

  const GetCountryDetailsEvent(this.countryName);

  @override
  List<Object> get props => [countryName];
}

class RefreshCountriesEvent extends CountriesEvent {}
