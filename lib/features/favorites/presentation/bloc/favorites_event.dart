import 'package:equatable/equatable.dart';

import '../../../countries/domain/entities/country.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final Country country;

  const ToggleFavoriteEvent(this.country);

  @override
  List<Object> get props => [country];
}

class AddToFavoritesEvent extends FavoritesEvent {
  final Country country;

  const AddToFavoritesEvent(this.country);

  @override
  List<Object> get props => [country];
}

class RemoveFromFavoritesEvent extends FavoritesEvent {
  final String countryId;

  const RemoveFromFavoritesEvent(this.countryId);

  @override
  List<Object> get props => [countryId];
}

class CheckIsFavoriteEvent extends FavoritesEvent {
  final String countryId;

  const CheckIsFavoriteEvent(this.countryId);

  @override
  List<Object> get props => [countryId];
}
