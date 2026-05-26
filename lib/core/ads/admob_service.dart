import 'dart:async';

import 'package:dhyan/core/ads/admob_config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Loads and shows AdMob rewarded ads on Android and iOS.
abstract final class AdMobService {
  static bool _initialized = false;

  static bool get isSupported {
    if (kIsWeb) return false;
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  static String get rewardedAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AdMobConfig.rewardedAdUnitIos;
    }
    return AdMobConfig.rewardedAdUnitAndroid;
  }

  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return AdMobConfig.bannerAdUnitIos;
    }
    return AdMobConfig.bannerAdUnitAndroid;
  }

  static bool get isBannerConfigured =>
      isSupported && bannerAdUnitId.isNotEmpty;

  static Future<void> initialize() async {
    if (!isSupported || _initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  /// Returns true if the user watched the ad (dismissed after show).
  static Future<bool> showRewardedAd({VoidCallback? onAdShown}) async {
    if (!isSupported) return false;

    final completer = Completer<bool>();
    RewardedAd? loadedAd;

    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          loadedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (_) => onAdShown?.call(),
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              if (!completer.isCompleted) completer.complete(true);
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint(
                'AdMob rewarded show failed [${error.code}]: ${error.message}',
              );
              ad.dispose();
              if (!completer.isCompleted) completer.complete(false);
            },
          );
          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {},
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint(
            'AdMob rewarded load failed [${error.code}]: ${error.message}',
          );
          if (!completer.isCompleted) completer.complete(false);
        },
      ),
    );

    try {
      return await completer.future.timeout(const Duration(seconds: 45));
    } on TimeoutException {
      loadedAd?.dispose();
      return false;
    }
  }
}
