import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../countries/domain/entities/country.dart';
import '../../domain/entities/favorite_country.dart';
import '../../domain/usecases/add_to_favorites.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/is_favorite.dart';
import '../../domain/usecases/remove_from_favorites.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddToFavorites addToFavorites;
  final RemoveFromFavorites removeFromFavorites;
  final IsFavorite isFavorite;

  // Cache to track favorite status for quick access
  final Map<String, bool> _favoriteCache = {};

  FavoritesBloc({
    required this.getFavorites,
    required this.addToFavorites,
    required this.removeFromFavorites,
    required this.isFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<AddToFavoritesEvent>(_onAddToFavorites);
    on<RemoveFromFavoritesEvent>(_onRemoveFromFavorites);
    on<CheckIsFavoriteEvent>(_onCheckIsFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavorites();
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favorites) {
        // Update cache
        _favoriteCache.clear();
        for (final fav in favorites) {
          _favoriteCache[fav.name] = true;
        }
        emit(FavoritesLoaded(favorites));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final country = event.country;
    final currentIsFavorite = _favoriteCache[country.name] ?? false;

    if (currentIsFavorite) {
      // Remove from favorites
      final result = await removeFromFavorites(country.name);
      result.fold(
        (failure) => emit(FavoritesError(failure.message)),
        (_) {
          _favoriteCache[country.name] = false;
          emit(FavoriteToggled(country.name, false));
          // Reload favorites to update the list
          add(LoadFavoritesEvent());
        },
      );
    } else {
      // Add to favorites
      final result = await addToFavorites(country);
      result.fold(
        (failure) => emit(FavoritesError(failure.message)),
        (_) {
          _favoriteCache[country.name] = true;
          emit(FavoriteToggled(country.name, true));
          // Reload favorites to update the list
          add(LoadFavoritesEvent());
        },
      );
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await addToFavorites(event.country);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        _favoriteCache[event.country.name] = true;
        emit(FavoriteToggled(event.country.name, true));
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await removeFromFavorites(event.countryId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (_) {
        _favoriteCache[event.countryId] = false;
        emit(FavoriteToggled(event.countryId, false));
        add(LoadFavoritesEvent());
      },
    );
  }

  Future<void> _onCheckIsFavorite(
    CheckIsFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    // Check cache first
    if (_favoriteCache.containsKey(event.countryId)) {
      emit(FavoriteChecked(event.countryId, _favoriteCache[event.countryId]!));
      return;
    }

    // If not in cache, check from storage
    final result = await isFavorite(event.countryId);
    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (isFav) {
        _favoriteCache[event.countryId] = isFav;
        emit(FavoriteChecked(event.countryId, isFav));
      },
    );
  }

  // Helper method to check if a country is favorite (synchronous)
  bool isCountryFavorite(String countryName) {
    return _favoriteCache[countryName] ?? false;
  }

  // Helper method to get current favorites list
  List<FavoriteCountry> getCurrentFavorites() {
    if (state is FavoritesLoaded) {
      return (state as FavoritesLoaded).favorites;
    }
    return [];
  }
}
