import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/countries_bloc.dart';
import '../../bloc/countries_event.dart';
import '../../bloc/countries_state.dart';
import '../../widgets/country_card.dart';
import '../../widgets/search_bar_widget.dart';
import '../detail/detail_page.dart';

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
    // Load countries when the page initializes
    context.read<CountriesBloc>().add(LoadCountriesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            // App Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Countries',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Theme.of(context).brightness == Brightness.dark
                          ? Icons.light_mode
                          : Icons.dark_mode,
                    ),
                    onPressed: () {
                      // Toggle theme - will be implemented with theme cubit
                    },
                  ),
                ],
              ),
            ),

            // Search Bar
            SearchBarWidget(
              controller: _searchController,
              onChanged: (value) {
                if (value.isEmpty) {
                  context.read<CountriesBloc>().add(LoadCountriesEvent());
                } else {
                  context
                      .read<CountriesBloc>()
                      .add(SearchCountriesEvent(value));
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
                  if (state is CountriesLoading ||
                      state is CountriesSearching) {
                    return const Center(
                      child: CircularProgressIndicator(),
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
                          return CountryCard(
                            country: country,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(country: country),
                                ),
                              );
                            },
                            onFavoritePressed: () {
                              // TODO: Handle favorite toggle
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Favorite ${country.name}'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            },
                            isFavorite:
                                false, // TODO: Check if country is in favorites
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
      ),
    );
  }
}
