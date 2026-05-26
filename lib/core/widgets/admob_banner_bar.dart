import 'package:dhyan/core/ads/admob_service.dart';
import 'package:dhyan/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Anchored banner above the main tab bar — home / activities / progress only.
/// Hidden when load fails so layout stays calm.
class AdMobBannerBar extends StatefulWidget {
  const AdMobBannerBar({super.key});

  @override
  State<AdMobBannerBar> createState() => _AdMobBannerBarState();
}

class _AdMobBannerBarState extends State<AdMobBannerBar> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _loadStarted = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadStarted) return;
    _loadStarted = true;
    _loadBanner();
  }

  Future<void> _loadBanner() async {
    if (!AdMobService.isSupported || !AdMobService.isBannerConfigured) return;

    final width = MediaQuery.sizeOf(context).width.truncate();
    final size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (!mounted || size == null) return;

    final banner = BannerAd(
      adUnitId: AdMobService.bannerAdUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint(
            'AdMob banner load failed [${error.code}]: ${error.message}',
          );
          ad.dispose();
        },
      ),
    );

    _bannerAd = banner;
    await banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final ad = _bannerAd!;
    return ColoredBox(
      color: AppTheme.deepNavy,
      child: Center(
        child: SizedBox(
          width: ad.size.width.toDouble(),
          height: ad.size.height.toDouble(),
          child: AdWidget(ad: ad),
        ),
      ),
    );
  }
}
