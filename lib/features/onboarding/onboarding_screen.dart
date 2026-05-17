import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _scrollHours = 2;
  bool _switchOften = true;
  double _discomfort = 4;
  bool _isSaving = false;

  Future<void> _onContinue() async {
    if (_isSaving) return;
    setState(() => _isSaving = true);

    try {
      await ref.read(userProgressProvider.notifier).completeOnboarding(
            scrollHours: _scrollHours,
            switchOften: _switchOften,
            discomfort: _discomfort.round(),
          );
      if (!mounted) return;
      context.go('/profile-setup');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save: $e'),
          backgroundColor: AppTheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final progress = ref.watch(userProgressProvider);

    if (progress.hasValue && progress.requireValue.profileComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/');
      });
    } else if (progress.hasValue && progress.requireValue.onboardingComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) context.go('/profile-setup');
      });
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.focusGradient),
        child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                s.onboardingTitle,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                s.onboardingSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Text(
                s.qScrollHours,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Slider(
                value: _scrollHours.toDouble(),
                min: 0,
                max: 4,
                divisions: 4,
                label: ['<1h', '1h', '2h', '3h', '3h+'][_scrollHours],
                onChanged: _isSaving
                    ? null
                    : (v) => setState(() => _scrollHours = v.round()),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(s.qSwitchApps),
                value: _switchOften,
                activeThumbColor: AppTheme.primary,
                onChanged: _isSaving ? null : (v) => setState(() => _switchOften = v),
              ),
              const SizedBox(height: 8),
              Text(
                s.qUncomfortable,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Slider(
                value: _discomfort,
                min: 1,
                max: 5,
                divisions: 4,
                label: _discomfort.round().toString(),
                onChanged: _isSaving ? null : (v) => setState(() => _discomfort = v),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _isSaving ? null : _onContinue,
                child: _isSaving
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppTheme.background,
                        ),
                      )
                    : Text(s.continueBtn),
              ),
              const SizedBox(height: 8),
              Text(
                s.disclaimer,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
