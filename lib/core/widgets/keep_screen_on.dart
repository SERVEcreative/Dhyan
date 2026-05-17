import 'package:flutter/material.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// Keeps the display awake while a focus activity or session is in progress.
class KeepScreenOn extends StatefulWidget {
  const KeepScreenOn({super.key, required this.child});

  final Widget child;

  @override
  State<KeepScreenOn> createState() => _KeepScreenOnState();
}

class _KeepScreenOnState extends State<KeepScreenOn> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _enable();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _enable();
    }
  }

  Future<void> _enable() async {
    await WakelockPlus.enable();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
