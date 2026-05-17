import 'package:flutter/material.dart';

/// Bottom inset for tab screens inside [MainShellScreen] (nav bar + safe area).
double shellScrollBottom(BuildContext context, {double extra = 20}) {
  return MediaQuery.paddingOf(context).bottom +
      kBottomNavigationBarHeight +
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
