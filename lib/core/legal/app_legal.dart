/// Legal / store metadata — update [privacyPolicyUrl] after publishing
/// `docs/privacy-policy.html` (e.g. GitHub Pages).
abstract final class AppLegal {
  static const String appName = 'Dhyan';
  static const String developerName = 'Serve Creative';
  static const String packageName = 'com.servecreative';
  static const String contactEmail = 'professional.rahul.business@gmail.com';

  /// Voluntary support UPI — update with your real UPI ID before wide release.
  static const String supportUpiId = 'servecreative@upi';

  static const String appVersion = '1.0.1';
  static const int appBuildNumber = 2;

  /// Public URL for Google Play Console (Privacy policy field).
  static const String privacyPolicyUrl =
      'https://servecreative.github.io/Dhyan/';

  static const String privacyPolicyLastUpdated = 'May 2026';
}
