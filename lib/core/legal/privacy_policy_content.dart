import 'package:dhyan/core/legal/app_legal.dart';

class PrivacySection {
  const PrivacySection({
    required this.titleEn,
    required this.titleHi,
    required this.bodyEn,
    required this.bodyHi,
  });

  final String titleEn;
  final String titleHi;
  final String bodyEn;
  final String bodyHi;

  String title(bool isHindi) => isHindi ? titleHi : titleEn;
  String body(bool isHindi) => isHindi ? bodyHi : bodyEn;
}

/// Shared privacy policy text (in-app + source for docs/privacy-policy.html).
abstract final class PrivacyPolicyContent {
  static final sections = [
    PrivacySection(
      titleEn: 'Overview',
      titleHi: 'Jaanakari',
      bodyEn:
          'Dhyan ("we", "our") is a focus-training app published by ${AppLegal.developerName}. '
          'This policy explains what information is used when you use the Android app '
          '${AppLegal.packageName}. By using Dhyan, you agree to this policy.',
      bodyHi:
          'Dhyan ("hum") ${AppLegal.developerName} dwara focus training app hai. '
          'Yeh policy batati hai ki Android app ${AppLegal.packageName} use karte waqt '
          'kaun si jaankari use hoti hai. App use karke aap is policy se sehmat hain.',
    ),
    PrivacySection(
      titleEn: 'Information stored on your device',
      titleHi: 'Aapke phone par stored data',
      bodyEn:
          'We store progress and preferences locally on your device (for example: '
          'sessions completed, attention index, skill track, language, and onboarding '
          'choices) using on-device storage. This data is not sent to our own servers. '
          'Uninstalling the app removes this local data.',
      bodyHi:
          'Hum aapki progress aur settings aapke phone par hi store karte hain '
          '(jaise sessions, attention index, track, language). Yeh data humare server '
          'par nahi bheja jata. App uninstall karne par yeh data delete ho jata hai.',
    ),
    PrivacySection(
      titleEn: 'Motion sensors',
      titleHi: 'Motion sensors',
      bodyEn:
          'Some drills (such as Still Point) may use your device motion sensors to '
          'detect stillness during an exercise. Sensor data is processed on your device '
          'for that activity and is not uploaded to our servers.',
      bodyHi:
          'Kuch drills (jaise Still Point) stillness check ke liye motion sensor use '
          'kar sakte hain. Yeh data sirf activity ke dauran device par process hota hai, '
          'server par nahi bheja jata.',
    ),
    PrivacySection(
      titleEn: 'Advertising (Google AdMob)',
      titleHi: 'Advertising (Google AdMob)',
      bodyEn:
          'If you choose to watch an optional rewarded ad, we use Google AdMob. Google '
          'may collect and process information such as advertising ID, device information, '
          'IP address, and ad interaction data to show and measure ads. '
          'See Google\'s Privacy Policy: https://policies.google.com/privacy\n\n'
          'You can reset or limit ad personalization in Android Settings → Google → Ads.',
      bodyHi:
          'Agar aap optional rewarded ad dekhte hain, to hum Google AdMob use karte hain. '
          'Google advertising ID, device info, IP address aur ad interaction data collect '
          'kar sakta hai. Google Privacy Policy: https://policies.google.com/privacy\n\n'
          'Android Settings → Google → Ads se aap ad personalization limit kar sakte hain.',
    ),
    PrivacySection(
      titleEn: 'Donations',
      titleHi: 'Donations',
      bodyEn:
          'The app may show a UPI ID for voluntary support. Payments happen outside the '
          'app in your bank or UPI app. We do not process in-app payments.',
      bodyHi:
          'App voluntary support ke liye UPI ID dikha sakti hai. Payment app ke bahar '
          'aapke bank/UPI app mein hoti hai. Hum in-app payment process nahi karte.',
    ),
    PrivacySection(
      titleEn: 'Permissions',
      titleHi: 'Permissions',
      bodyEn:
          'Internet — required for optional ads and general app functionality.\n'
          'Advertising ID — used by ad networks where applicable.\n'
          'Keep screen on — used during active exercises so your session is not interrupted.',
      bodyHi:
          'Internet — ads aur app ke liye.\n'
          'Advertising ID — jahan ads use hote hain.\n'
          'Screen on — exercises ke dauran screen band hone se rokne ke liye.',
    ),
    PrivacySection(
      titleEn: 'Children',
      titleHi: 'Bachche',
      bodyEn:
          'Dhyan is not directed at children under 13. We do not knowingly collect '
          'personal information from children.',
      bodyHi:
          'Dhyan 13 saal se kam umr ke bachchon ke liye nahi hai. Hum jaan-bujh kar '
          'bachchon se personal data collect nahi karte.',
    ),
    PrivacySection(
      titleEn: 'Changes',
      titleHi: 'Changes',
      bodyEn:
          'We may update this policy. The "Last updated" date will change when we do. '
          'Continued use after changes means you accept the updated policy.',
      bodyHi:
          'Hum policy update kar sakte hain. "Last updated" date badlegi. Update ke '
          'baad app use karna nayi policy manna hai.',
    ),
    PrivacySection(
      titleEn: 'Contact',
      titleHi: 'Contact',
      bodyEn: 'Questions about privacy: ${AppLegal.contactEmail}',
      bodyHi: 'Privacy se judi query: ${AppLegal.contactEmail}',
    ),
  ];
}
