import 'package:dhyan/core/theme/app_theme.dart';
import 'package:dhyan/data/models/user_profile.dart';
import 'package:dhyan/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  AgeRange _age = AgeRange.age18to24;
  FocusGoal _goal = FocusGoal.reduceReels;
  PracticeSlot _slot = PracticeSlot.evening;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(userProgressProvider.notifier).saveProfile(
            displayName: _nameController.text,
            ageRange: _age,
            focusGoal: _goal,
            practiceSlot: _slot,
          );
      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e'), backgroundColor: AppTheme.error),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(stringsProvider);
    final isHi = s.isHindi;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.focusGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(s.profileTitle, style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(s.profileSubtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 8),
                Text(s.profilePrivacy, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: s.nameLabel,
                    hintText: s.nameHint,
                  ),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 20),
                Text(s.ageLabel, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: AgeRange.values.map((a) {
                    return ChoiceChip(
                      label: Text(isHi ? a.labelHi() : a.labelEn()),
                      selected: _age == a,
                      onSelected: _saving ? null : (_) => setState(() => _age = a),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(s.goalLabel, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                ...FocusGoal.values.map((g) {
                  return RadioListTile<FocusGoal>(
                    title: Text(isHi ? g.labelHi() : g.labelEn()),
                    value: g,
                    groupValue: _goal,
                    activeColor: AppTheme.focusBlue,
                    onChanged: _saving ? null : (v) => setState(() => _goal = v!),
                  );
                }),
                const SizedBox(height: 8),
                Text(s.practiceTimeLabel, style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 8),
                SegmentedButton<PracticeSlot>(
                  segments: PracticeSlot.values
                      .map(
                        (p) => ButtonSegment(
                          value: p,
                          label: Text(
                            isHi ? p.labelHi() : p.labelEn(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  selected: {_slot},
                  onSelectionChanged: _saving
                      ? null
                      : (s) => setState(() => _slot = s.first),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(s.startJourney),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
