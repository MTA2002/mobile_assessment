import 'package:equatable/equatable.dart';

import '../../domain/entities/favorite_country.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteCountry> favorites;

  const FavoritesLoaded(this.favorites);

  @override
  List<Object> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoriteChecked extends FavoritesState {
  final String countryId;
  final bool isFavorite;

  const FavoriteChecked(this.countryId, this.isFavorite);

  @override
  List<Object> get props => [countryId, isFavorite];
}

class FavoriteToggled extends FavoritesState {
  final String countryId;
  final bool isFavorite;

  const FavoriteToggled(this.countryId, this.isFavorite);

  @override
  List<Object> get props => [countryId, isFavorite];
}
