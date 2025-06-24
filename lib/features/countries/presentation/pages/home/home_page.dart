import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/animated_theme_toggle.dart';
import '../../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../../favorites/presentation/bloc/favorites_state.dart';
import '../../bloc/countries_bloc.dart';
import '../../bloc/countries_event.dart';
import '../../bloc/countries_state.dart';

import '../../widgets/shimmer_country_card.dart';
import '../../widgets/animated_country_card.dart';
import '../../widgets/animated_search_bar.dart';
import '../detail/detail_page.dart';
import '../../../../../core/utils/page_transitions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load countries and favorites when the page initializes
    context.read<CountriesBloc>().add(LoadCountriesEvent());
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Countries'),
        centerTitle: false,
        actions: [
          const AnimatedThemeToggle(),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          AnimatedSearchBar(
            controller: _searchController,
            onChanged: (value) {
              if (value.isEmpty) {
                context.read<CountriesBloc>().add(LoadCountriesEvent());
              } else {
                context.read<CountriesBloc>().add(SearchCountriesEvent(value));
              }
            },
            onClear: () {
              context.read<CountriesBloc>().add(LoadCountriesEvent());
            },
          ),

          // Countries Grid
          Expanded(
            child: BlocBuilder<CountriesBloc, CountriesState>(
              builder: (context, state) {
                if (state is CountriesLoading || state is CountriesSearching) {
                  return GridView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 8, // Show 8 shimmer cards
                    itemBuilder: (context, index) {
                      return TweenAnimationBuilder<double>(
                        duration: Duration(milliseconds: 200 + (index * 100)),
                        tween: Tween(begin: 0.0, end: 1.0),
                        curve: Curves.easeOutCubic,
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Opacity(
                              opacity: value,
                              child: const ShimmerCountryCard(),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is CountriesError ||
                    state is CountryDetailsError) {
                  final message = state is CountriesError
                      ? state.message
                      : (state as CountryDetailsError).message;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<CountriesBloc>()
                                .add(RefreshCountriesEvent());
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is CountriesEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context)
                              .iconTheme
                              .color
                              ?.withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                } else if (state is CountriesLoaded ||
                    state is CountriesSearchLoaded) {
                  final countries = state is CountriesLoaded
                      ? state.countries
                      : (state as CountriesSearchLoaded).countries;

                  return RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<CountriesBloc>()
                          .add(RefreshCountriesEvent());
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: countries.length,
                      itemBuilder: (context, index) {
                        final country = countries[index];
                        return BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, favoritesState) {
                            // Check if country is favorite
                            bool isFavorite = false;
                            if (favoritesState is FavoritesLoaded) {
                              isFavorite = favoritesState.favorites
                                  .any((fav) => fav.name == country.name);
                            } else {
                              // Use bloc's cache method for quick check
                              isFavorite = context
                                  .read<FavoritesBloc>()
                                  .isCountryFavorite(country.name);
                            }

                            return AnimatedCountryCard(
                              country: country,
                              index: index,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransitions.slideTransition(
                                    DetailPage(country: country),
                                  ),
                                );
                              },
                              onFavoritePressed: () {
                                // Toggle favorite using the favorites bloc
                                context
                                    .read<FavoritesBloc>()
                                    .add(ToggleFavoriteEvent(country));
                              },
                              isFavorite: isFavorite,
                            );
                          },
                        );
                      },
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
