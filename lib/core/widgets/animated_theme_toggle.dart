import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../theme/theme_cubit.dart';

class AnimatedThemeToggle extends StatefulWidget {
  const AnimatedThemeToggle({super.key});

  @override
  State<AnimatedThemeToggle> createState() => _AnimatedThemeToggleState();
}

class _AnimatedThemeToggleState extends State<AnimatedThemeToggle>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  IconData _getThemeIcon(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode;
  }

  String _getThemeTooltip(ThemeMode themeMode) {
    return themeMode == ThemeMode.dark
        ? 'Switch to light theme'
        : 'Switch to dark theme';
  }

  void _onThemeToggle() {
    _scaleController.forward().then((_) {
      context.read<ThemeCubit>().toggleTheme();
      _rotationController.forward().then((_) {
        _rotationController.reset();
        _scaleController.reverse();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return AnimatedBuilder(
          animation: Listenable.merge([_rotationAnimation, _scaleAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 3.14159, // 180 degrees
                child: IconButton(
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) {
                      return RotationTransition(
                        turns: animation,
                        child: child,
                      );
                    },
                    child: Icon(
                      _getThemeIcon(state.themeMode),
                      key: ValueKey(state.themeMode),
                    ),
                  ),
                  onPressed: _onThemeToggle,
                  tooltip: _getThemeTooltip(state.themeMode),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
