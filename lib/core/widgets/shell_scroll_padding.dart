import 'package:dhyan/core/ads/admob_service.dart';
import 'package:flutter/material.dart';

/// Space for optional banner + tab bar + safe area on main shell tabs.
const double kShellBannerReserve = 52;

/// Bottom inset for tab screens inside [MainShellScreen] (nav bar + safe area).
double shellScrollBottom(BuildContext context, {double extra = 20}) {
  final bannerReserve =
      AdMobService.isBannerConfigured ? kShellBannerReserve : 0.0;
  return MediaQuery.paddingOf(context).bottom +
      kBottomNavigationBarHeight +
      bannerReserve +
      extra;
}

EdgeInsets shellScrollInsets(
  BuildContext context, {
  double horizontal = 16,
  double top = 8,
  double extraBottom = 20,
}) {
  return EdgeInsets.fromLTRB(
    horizontal,
    top,
    horizontal,
    shellScrollBottom(context, extra: extraBottom),
  );
}
