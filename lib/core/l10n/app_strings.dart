import 'package:dhyan/core/legal/app_legal.dart';
import 'package:dhyan/data/models/skill_track.dart';

enum AppLocale { en, hi }

class AppStrings {
  AppStrings(this.locale);

  final AppLocale locale;
  bool get isHindi => locale == AppLocale.hi;

  String get appTitle => isHindi ? 'ध्यान' : 'Dhyan';
  String get tagline => isHindi
      ? 'Reels se attention wapas'
      : 'Reclaim attention from Reels';
  String get minimalTagline => isHindi
      ? 'Scroll kam. Focus zyada.'
      : 'Less scroll. More focus.';
  String get homeAttentionHint => isHindi
      ? 'Roz thodi practice se badhega'
      : 'Grows with daily practice';
  String get homeSessionTitle =>
      isHindi ? 'Aaj ki focus session' : "Today's focus session";

  String get startSession => isHindi ? 'Session shuru' : 'Start session';
  String get microSession => isHindi ? 'Micro (3 min)' : 'Micro (3 min)';
  String get quickSession => isHindi ? 'Quick (5 min)' : 'Quick (5 min)';
  String get focus7Session =>
      isHindi ? 'Universal Focus (7 min)' : 'Universal Focus (7 min)';
  String get calmSession => isHindi ? 'Calm (10 min)' : 'Calm (10 min)';
  String get deepSession => isHindi ? 'Deep (12 min)' : 'Deep (12 min)';
  String get extendedSession =>
      isHindi ? 'Extended (15 min)' : 'Extended (15 min)';

  String sessionTitle(SessionType type) => switch (type) {
        SessionType.micro => microSession,
        SessionType.quick => quickSession,
        SessionType.focus7 => focus7Session,
        SessionType.calm => calmSession,
        SessionType.deep => deepSession,
        SessionType.extended => extendedSession,
      };

  String sessionSubtitle(SessionType type) => switch (type) {
        SessionType.micro => activityMicroDesc,
        SessionType.quick => isHindi
            ? 'Chhoti chain — jaldi reset'
            : 'Short chain — quick reset',
        SessionType.focus7 => isHindi
            ? 'Kisi bhi kaam se pehle — focus prep'
            : 'Before any task — focus prep',
        SessionType.calm => isHindi
            ? 'Shaant drills — beech ka balance'
            : 'Calm drills — middle balance',
        SessionType.deep => activityDeepDesc,
        SessionType.extended => isHindi
            ? 'Lambi training — zyada drills'
            : 'Longer training — more drills',
      };

  String get sessionMicroLimitReached => isHindi
      ? 'Aaj ki chhoti sessions ki limit'
      : "Today's short session limit reached";
  String get sessionDeepLimitReached => isHindi
      ? 'Aaj ki deep session limit'
      : "Today's deep session limit reached";
  String get sessionDeepLockedTrack => isHindi
      ? 'Deep Builder track par unlock'
      : 'Deep unlocks on Builder track';
  String get sessionFocus7LimitReached => isHindi
      ? 'Aaj ki 7-min prep limit — kal phir'
      : "Today's 7-min prep limit — try tomorrow";
  String get progress => isHindi ? 'Progress' : 'Progress';
  String get attentionIndex => isHindi ? 'Attention Index' : 'Attention Index';
  String get urgeSurf => isHindi ? 'Urge Surf' : 'Urge Surf';
  String get dailyDeck => isHindi ? 'Aaj ke techniques' : "Today's techniques";
  String get trackRecovery =>
      isHindi ? 'Recovery (Beginner)' : 'Recovery (Beginner)';
  String get trackBuilder =>
      isHindi ? 'Builder (Intermediate)' : 'Builder (Intermediate)';
  String get trackMaster => isHindi ? 'Master (Advanced)' : 'Master (Advanced)';

  String get onboardingTitle =>
      isHindi ? 'Apna level chuno' : 'Choose your level';
  String get onboardingSubtitle => isHindi
      ? 'Shorts/Reels se attention kam hui? Honest answers = better plan.'
      : 'Lost focus to shorts? Honest answers = better plan.';

  String get profileTitle =>
      isHindi ? 'Apne baare mein batao' : 'Tell us about you';
  String get profileSubtitle => isHindi
      ? 'Personalized estimates ke liye — data device par hi rehta hai.'
      : 'For personalized estimates — data stays on your device.';
  String get profilePrivacy => isHindi
      ? 'Naam optional. Koi account / social login nahi.'
      : 'Name optional. No account or social login required.';
  String get nameLabel => isHindi ? 'Naam (optional)' : 'Name (optional)';
  String get nameHint => isHindi ? 'e.g. Rahul' : 'e.g. Alex';
  String get ageLabel => isHindi ? 'Umar' : 'Age range';
  String get goalLabel => isHindi ? 'Main goal' : 'Main goal';
  String get practiceTimeLabel =>
      isHindi ? 'Practice ka best time' : 'Best time to practice';
  String get startJourney => isHindi ? 'Shuru karo' : 'Start journey';

  String get qScrollHours =>
      isHindi ? 'Roz kitni der shorts/Reels?' : 'Daily shorts/Reels time?';
  String get qSwitchApps => isHindi
      ? 'Session beech mein app switch?'
      : 'Switch apps mid-session?';
  String get qUncomfortable => isHindi
      ? 'Bina phone uncomfortable? (1-5)'
      : 'Uncomfortable without phone? (1-5)';

  String get continueBtn => isHindi ? 'Aage badho' : 'Continue';
  String get breathAnchor => isHindi ? 'Breath Anchor' : 'Breath Anchor';
  String get stillPoint => isHindi ? 'Still Point' : 'Still Point';
  String get onePath => isHindi ? 'One Path' : 'One Path';
  String get colorFocus => isHindi ? 'Color Focus' : 'Color Focus';
  String get colorFocusHint => isHindi
      ? 'Safed bindu par focus karo — nazar wahi rakho'
      : 'Focus on the white dot — keep your gaze there';
  String get boredomBench => isHindi ? 'Boredom Bench' : 'Boredom Bench';
  String get boredomHint => isHindi
      ? 'Kuch mat karo. Yeh feeling normal hai.'
      : 'Do nothing. This feeling is normal.';
  String get warmup => isHindi ? 'Warm-up' : 'Warm-up';
  String get sessionComplete =>
      isHindi ? 'Session complete' : 'Session complete';
  String get congratsTitle => isHindi ? 'Badhai ho!' : 'Congratulations!';
  String congratsSessionDone(int min) => isHindi
      ? 'Aapne $min min ki focus session poori kar li.'
      : 'You finished your $min min focus session.';
  String get earlyStageHelpRequest => isHindi
      ? 'Hum abhi bahut initial stage par hain. Agar Dhyan aapko helpful laga, please thodi support karo — ya aankh band karke ek chhota ad moment dekh lo. Isse app free reh sakti hai.'
      : 'We are at a very early stage. If Dhyan helped you, please support us — or watch a short ad moment with eyes closed. It helps keep the app free.';
  String get congratsWatchAd => isHindi
      ? 'Aankh band karke ad dekho'
      : 'Watch ad (eyes closed)';
  String get congratsDonate =>
      isHindi ? 'Thoda donate karo' : 'Donate a little';
  String get congratsMaybeLater =>
      isHindi ? 'Baad mein, summary dekho' : 'Maybe later, see summary';
  String get closeMindfully =>
      isHindi ? 'Mindfully band karo' : 'Close mindfully';
  String get noMoreRounds => isHindi
      ? 'Aaj ke liye bas — kal milte hain'
      : "That's enough for today — see you tomorrow";
  String get supportTitle =>
      isHindi ? 'Dhyan ko support karo?' : 'Support Dhyan?';
  String get supportSubtitle => isHindi
      ? 'Free app hai — aapki help se aur logon tak focus training pahunchti hai.'
      : 'This app is free — your support helps more people train focus.';
  String get supportEyesClosedTitle =>
      isHindi ? 'Aankh band karke sponsor moment' : 'Eyes closed — sponsor moment';
  String get supportEyesClosedHint => isHindi
      ? 'Jab video shuru ho, aankh band rakho. Ad khatam hone tak screen mat chhedo.'
      : 'When the video starts, keep your eyes closed. Do not touch the screen until it ends.';
  String get supportEyesClosedDone =>
      isHindi ? 'Shukriya — aapne support diya' : 'Thank you — you supported us';
  String get supportAdLoading => isHindi
      ? 'Sponsor ad load ho rahi hai…'
      : 'Loading sponsor ad…';
  String get supportAdFailed => isHindi
      ? 'Ad abhi load nahi ho payi. Baad mein try karo.'
      : 'Could not load the ad right now. Try again later.';
  String get supportAdWebOnly => isHindi
      ? 'Rewarded ads sirf Android/iOS app par available hain.'
      : 'Rewarded ads are available on the Android and iOS app only.';
  String get supportDonateTitle =>
      isHindi ? 'Donate karo' : 'Donate';
  String get supportDonateHint => isHindi
      ? 'Jo chaaho utna — UPI / Pay se. Har rupaya focus tools banane mein jata hai.'
      : 'Any amount via UPI / Pay. Every bit builds focus tools.';
  String get supportDonateCopy =>
      isHindi ? 'UPI ID copy karo' : 'Copy UPI ID';
  String get supportDonateCopied =>
      isHindi ? 'UPI ID copy ho gayi' : 'UPI ID copied';
  String get supportUpiPlaceholder => AppLegal.supportUpiId;
  String get breathInhale => isHindi ? 'Saans andar (4)' : 'Breathe in (4)';
  String get breathHold => isHindi ? 'Roko (7)' : 'Hold (7)';
  String get breathExhale => isHindi ? 'Saans bahar (8)' : 'Breathe out (8)';
  String get aboutTitle => isHindi ? 'About Dhyan' : 'About Dhyan';
  String get aboutVersion => isHindi ? 'Version' : 'Version';
  String get aboutCompanyName =>
      isHindi ? 'Company naam' : 'Company name';
  String get aboutMailBox => isHindi ? 'Mail box' : 'Mail box';
  String get aboutMailBoxTap =>
      isHindi ? 'Email kholo' : 'Open email';
  String get supportSkip =>
      isHindi ? 'Abhi nahi, home jao' : 'Not now, go home';
  String get privacyPolicyTitle =>
      isHindi ? 'Privacy Policy' : 'Privacy Policy';
  String privacyPolicyUpdated(String date) => isHindi
      ? 'Last updated: $date'
      : 'Last updated: $date';
  String get privacyPolicyOpenWeb => isHindi
      ? 'Web par kholo'
      : 'Open on web';
  String get privacyPolicyLink =>
      isHindi ? 'Privacy Policy' : 'Privacy Policy';

  String get supportContinue =>
      isHindi ? 'Support screen par jao' : 'Continue';
  String get holdStill =>
      isHindi ? 'Phone still rakho' : 'Hold phone still';
  String get fingerHold =>
      isHindi ? 'Finger screen par rakho' : 'Hold finger on screen';
  String get distractionIgnore => isHindi
      ? 'Notification ignore karo'
      : 'Ignore the notification';
  String get wrongTurnWait =>
      isHindi ? 'Ruko... impulse control' : 'Wait... impulse control';
  String get streak => isHindi ? 'Streak' : 'Streak';
  String get paused => isHindi ? 'Paused' : 'Paused';
  String get sustained => isHindi ? 'Sustained' : 'Sustained';
  String get selective => isHindi ? 'Selective' : 'Selective';
  String get inhibitory => isHindi ? 'Inhibitory' : 'Inhibitory';
  String get cognitive => isHindi ? 'Cognitive' : 'Cognitive';
  String get language => isHindi ? 'Bhasha' : 'Language';
  String get english => 'English';
  String get hindi => 'हिंदी';
  String get disclaimer => isHindi
      ? 'Wellness tool — medical treatment nahi. Estimates approximate hain.'
      : 'Wellness tool — not medical treatment. Estimates are approximate.';

  String get estimatedBenefit =>
      isHindi ? 'Aaj ka estimated faida' : "Today's estimated benefit";
  String get attentionGain =>
      isHindi ? 'Attention Index gain' : 'Attention Index gain';
  String get readingEquiv =>
      isHindi ? 'Deep reading focus equiv.' : 'Deep reading focus equiv.';
  String get impulseBoost =>
      isHindi ? 'Impulse control boost' : 'Impulse control boost';
  String get estimateDisclaimer => isHindi
      ? 'Model-based estimate; har user alag. Clinical claim nahi.'
      : 'Model-based estimate; results vary. Not a clinical claim.';
  String get totalTrained =>
      isHindi ? 'Kul focus training' : 'Total focus training';
  String get sinceStart => isHindi ? 'Shuru se' : 'Since you started';
  String get weeklyProjection =>
      isHindi ? '7 din projection' : '7-day projection';
  String get colorScience => isHindi
      ? 'Blue = focus, Green = restore, low arousal = better attention'
      : 'Blue = focus, Green = restore, low arousal = better attention';
  String get quickDrills => isHindi ? 'Quick drills' : 'Quick drills';

  String get antiReelTitle =>
      isHindi ? 'Reels urge aaye?' : 'Reels urge hitting?';
  String get antiReelSubtitle => isHindi
      ? '60s tools — feed nahi, training'
      : '60s tools — not a feed, training';
  String get swipeResist => isHindi ? 'Swipe Resist' : 'Swipe Resist';
  String get swipeResistShort => isHindi ? 'No Swipe' : 'No Swipe';
  String get swipeResistHint => isHindi
      ? 'Mann karega swipe karne ka… par mat karo. Yahi training hai.'
      : 'You\'ll want to swipe… but don\'t. That\'s the whole training.';
  String get swipeResistSwipeCue =>
      isHindi ? 'Agla video ↑' : 'Next video ↑';
  String get swipeResistPopupTitle =>
      isHindi ? 'Arre, mat karo na…' : 'Hey, please don\'t…';
  String get swipeResistPopupButton =>
      isHindi ? 'Theek hai, focus karta hoon' : 'Okay, I\'ll stay focused';
  String swipeAttempts(int n) =>
      isHindi ? 'Swipe tries: $n (sab urges — resist!)' : 'Swipe tries: $n (resist each one!)';

  static const _swipeFocusQuotesEn = [
    'Please focus, friend — don\'t swipe. Your attention span is rooting for you.',
    'I\'m not mad, just a little sad… stay with this moment instead of scrolling.',
    'That swipe urge is loud, but you\'re stronger. Breathe, don\'t flick.',
    'Reels win when you swipe without thinking. You win when you pause.',
    'Almost swiped? That\'s okay — come back. Focus is gentle, not harsh.',
    'Your brain wanted a hit. Give it calm instead. No swipe needed.',
    'Please don\'t go — one minute of stillness beats an hour of feeds.',
    'The feed can wait. You\'re training something more important right now.',
  ];

  static const _swipeFocusQuotesHi = [
    'Please focus, dost — swipe mat karo. Aapka attention span aapke saath hai.',
    'Gussa nahi, thoda udaas hoon… scroll ki jagah is pal mein raho.',
    'Swipe ki ichha tez hai, par aap zyada strong ho. Saans lo, flick mat.',
    'Sochte bina swipe = Reels jeet gaye. Rukna = aap jeet gaye.',
    'Almost swipe? Koi baat nahi — wapas aao. Focus soft hai, hard nahi.',
    'Dimaag ko hit chahiye thi. Usse shaanti do. Swipe zaroori nahi.',
    'Please mat jao — ek minute shanti, ek ghante reels se behtar.',
    'Feed ruk sakti hai. Ab aap kuch zyada important train kar rahe ho.',
  ];

  String randomSwipeResistQuote() {
    final quotes = isHindi ? _swipeFocusQuotesHi : _swipeFocusQuotesEn;
    return quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
  }

  String get fakeReelLabel =>
      isHindi ? 'Agla clip load ho raha…' : 'Loading next clip…';
  String get fakeReelLabel2 =>
      isHindi ? 'Trending abhi' : 'Trending now';
  String get fakeReelLabel3 =>
      isHindi ? 'Bas ek aur…' : 'Just one more…';
  String get delayTap => isHindi ? 'Delay Tap' : 'Delay Tap';
  String get delayTapShort => isHindi ? 'Wait' : 'Wait';
  String get delayTapWait => isHindi
      ? 'Reward ke liye ruko — Reels instant nahi'
      : 'Wait for reward — Reels are instant, you are not';
  String get delayTapReady => isHindi ? 'Ab tayyar ho' : 'Now you may tap';
  String get delayTapLocked => isHindi ? 'Abhi nahi...' : 'Not yet...';
  String get delayTapButton => isHindi ? 'Earned — tap karo' : 'Earned — tap';
  String get delayTapEarly => isHindi
      ? 'Jaldi tap = Reels jaisa brain'
      : 'Early tap = Reels brain';
  String get intentLock => isHindi ? 'Intent Lock' : 'Intent Lock';
  String get intentLockHint => isHindi
      ? 'Apna sentence 3 baar padho — scroll se pehle'
      : 'Read your line 3 times — before you scroll';
  String get intentLockTap => isHindi ? 'Padh liya' : 'I read it';
  String get urgeShort => isHindi ? 'Urge' : 'Urge';
  String get reelsLogTitle =>
      isHindi ? 'Aaj kitni der Reels?' : 'Reels minutes today?';
  String get reelsLogHint => isHindi
      ? 'Honest log — shame nahi. Bas track.'
      : 'Honest log — no shame. Just track.';
  String get reelsLogSave => isHindi ? 'Save' : 'Save';
  String get reelsLogCta =>
      isHindi ? 'Aaj ki Reels time log karo' : "Log today's Reels time";
  String reelsLogged(int m) =>
      isHindi ? 'Aaj log: $m min Reels' : 'Logged today: $m min Reels';

  String get allActivities => isHindi ? 'Saari activities' : 'All activities';
  String get categoryAntiReel =>
      isHindi ? 'Reels ke khilaf' : 'Anti-Reels';
  String get categoryFocus => isHindi ? 'Focus training' : 'Focus training';
  String get categorySessions => isHindi ? 'Poori session' : 'Full sessions';
  String get urgeSurfHint => isHindi
      ? 'Urge observe karo, fight mat karo'
      : 'Observe urge, do not fight it';
  String get activityBreathDesc => isHindi
      ? '4-7-8 saans — calm start'
      : '4-7-8 breath — calm start';
  String get activityMicroDesc => isHindi
      ? '3 drills chain — track ke hisaab se'
      : '3 drills in a row — based on your track';
  String get activityDeepDesc => isHindi
      ? 'Zyada drills — strong training'
      : 'More drills — stronger training';
  String get activityDuration60 => isHindi ? '1 min' : '1 min';
  String get activityDuration10 => isHindi ? '10 sec' : '10 sec';
  String get activityDuration90 => isHindi ? '90 sec' : '90 sec';
  String get activityDuration45 => isHindi ? '45 sec' : '45 sec';
  String get activityDuration50 => isHindi ? '50 sec' : '50 sec';
  String get activityDurationRead3 => isHindi ? '3× read' : '3× read';
  String get activityDurationVaries =>
      isHindi ? 'Flexible' : 'Flexible';
  String get activityDuration45to90 =>
      isHindi ? '45–90 sec' : '45–90 sec';
  String get activityDuration3min => isHindi ? '3 min' : '3 min';
  String get sessionLimitReached => isHindi
      ? 'Aaj ki limit ho gayi'
      : "Today's limit reached";
  String get navHome => isHindi ? 'Home' : 'Home';

  String get exitDialogTitle =>
      isHindi ? 'Ruko — focus chhodna mat' : 'Wait — don\'t drop focus';
  String get exitDialogSubtitle => isHindi
      ? 'Attention span tabhi badhti hai jab aap practice chhodte nahi.'
      : 'Your attention span grows when you don\'t quit mid-practice.';
  String get exitStayFocused =>
      isHindi ? 'Focus par raho' : 'Stay & focus';
  String get exitLeaveAnyway =>
      isHindi ? 'Phir bhi bahar jao' : 'Leave anyway';

  String get leaveSessionTitle =>
      isHindi ? 'Session beech mein chhod rahe ho?' : 'Leaving mid-session?';
  String get leaveSessionSubtitle => isHindi
      ? 'Attention tabhi badhegi jab aap beech mein nahi chhodoge.'
      : 'Attention grows when you stop quitting halfway.';
  String get leaveSessionStay =>
      isHindi ? 'Theek hai, session poori karunga' : 'Okay, I\'ll finish the session';
  String get leaveSessionQuit =>
      isHindi ? 'Haar maan li, chhod deta hoon' : 'I give up, leave session';

  static const _leaveSessionQuotesEn = [
    'Will you ever stick with it? Your attention span won\'t heal if you keep running.',
    'Again halfway out — same muscle memory as doom-scrolling away.',
    'You started this to get better. Quitting now teaches your brain the old habit.',
    'When will you choose focus over escape? Today was your chance.',
    'Every early exit is practice for giving up. That\'s not why you opened Dhyan.',
    'So close, yet leaving — reels win when you don\'t finish what you start.',
    'Your future self wanted you to stay. Don\'t disappoint them again.',
    'Kabhi sudhroge? Start by not abandoning this one session.',
  ];

  static const _leaveSessionQuotesHi = [
    'Kabhi poora tikoge? Beech mein bhagoge to attention span theek nahi hogi.',
    'Phir beech mein chhod diya — doom-scroll chhodne jaisi aadat.',
    'Sudharne aaye the. Ab chhodoge to dimaag purani aadat seekhega.',
    'Focus kab chunoge? Aaj mauka tha.',
    'Har jaldi exit = haar maanna seekhna. Dhyan isliye nahi khola tha.',
    'Itna paas aake chhod diya — jo shuru karte ho, poora karna seekho.',
    'Future wala aap chahte the ruko. Use phir mat mayoos karo.',
    'Kabhi sudhroge? Pehle yeh session mat todo.',
  ];

  String randomLeaveSessionQuote() {
    final quotes = isHindi ? _leaveSessionQuotesHi : _leaveSessionQuotesEn;
    return quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
  }

  static const _exitQuotesEn = [
    'Leaving now? You lose the attention span you came here to rebuild.',
    'Every quick exit trains your brain like a Reels swipe — stay one more minute.',
    'Scroll feeds shrink focus. A few more minutes here actually restore it.',
    'The urge to leave is the drill. Breathe, then choose focus.',
    'You opened Dhyan to reclaim attention — not hand it back to distraction.',
    'Stillness compounds. Walk away and today\'s progress pauses with you.',
    'Your brain learns what you repeat. Repeat focus, not escape.',
    'Short sessions beat endless scrolling — finish this one before you go.',
    'Attention is a muscle. You don\'t leave mid-rep at the gym either.',
    'One more calm minute now beats an hour of reels later.',
  ];

  static const _exitQuotesHi = [
    'Abhi jaoge? Jo attention span banani thi, wahi khone lagoge.',
    'Har jaldi exit Reels swipe jaisi aadat banati hai — ek minute aur ruko.',
    'Scroll focus chhota karta hai. Yahan kuch minute aur usse wapas laate hain.',
    'Jaane ki ichha hi drill hai. Saans lo, phir focus chuno.',
    'Dhyan attention ke liye khola tha — distraction ko wapas mat do.',
    'Shanti badhti hai. Chale gaye to aaj ki progress ruk jati hai.',
    'Dimaag wahi seekhta hai jo aap repeat karte ho. Focus repeat karo, bhagna nahi.',
    'Chhoti session lambi reels se behtar — jaane se pehle yeh poori karo.',
    'Attention ek muscle hai. Gym mein beech rep mein nahi chhodte.',
    'Ab ek shaant minute, baad mein reels ka ek ghanta behtar hai.',
  ];

  String randomExitQuote() {
    final quotes = isHindi ? _exitQuotesHi : _exitQuotesEn;
    final i = DateTime.now().millisecondsSinceEpoch % quotes.length;
    return quotes[i];
  }

  String greeting(String name) =>
      isHindi ? 'Namaste, $name' : 'Hello, $name';

  String secondsLabel(int s) => isHindi ? '$s sekand' : '${s}s';
  String minutesUnit(int m) => isHindi ? '$m min' : '$m min';
  String tomorrowTarget(int s) => isHindi
      ? 'Kal target: ${s}s still'
      : 'Tomorrow target: ${s}s still';
  String indexSinceBaseline(double gain) => isHindi
      ? 'Baseline se +${gain.toStringAsFixed(0)} points'
      : '+${gain.toStringAsFixed(0)} points since baseline';
}
