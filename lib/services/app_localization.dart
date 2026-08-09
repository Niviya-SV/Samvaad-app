import 'package:flutter/foundation.dart';
import 'app_storage.dart';

class AppLocalization {
  static String language = 'English';

  static final ValueNotifier<String> languageNotifier =
  ValueNotifier<String>('English');

  static Future<void> load() async {
    final savedLanguage = await AppStorage.getLanguage();

    language = savedLanguage;
    languageNotifier.value = savedLanguage;
  }

  static Future<void> changeLanguage(String value) async {
    language = value;
    languageNotifier.value = value;

    await AppStorage.saveLanguage(value);
  }

  static String t(String key) {
    final currentLanguage = language;

    final selected =
        _translations[currentLanguage] ??
            _translations['English']!;

    return selected[key] ??
        _translations['English']![key] ??
        key;
  }

  static const Map<String, Map<String, String>> _translations = {
    // ==========================================================
    // ENGLISH
    // ==========================================================

    'English': {
      'home': 'Home',
      'learn': 'Learn',
      'practice': 'Practice',
      'profile': 'Profile',
      'settings': 'Settings',
      'notifications': 'Notifications',

      'hello': 'Hello',
      'ready_to_learn':
      'Ready to learn Indian Sign Language?',

      'continue_learning': 'Continue Learning',
      'view_all': 'View all',
      'greetings': 'Greetings',
      'continue_current_lesson':
      'Continue your current lesson',
      'lesson_progress': 'Lesson progress',

      'todays_goal': "Today's Goal",
      'daily_learning_goal':
      'Daily learning goal',
      'lesson_remaining':
      '1 lesson remaining',

      'learning_path':
      'Your Learning Path',

      'beginner': 'Beginner',
      'intermediate': 'Intermediate',
      'advanced': 'Advanced',

      'build_foundations':
      'Build your foundations',

      'build_fluency':
      'Build fluency and confidence',

      'master_communication':
      'Master complex communication',

      'current': 'CURRENT',

      'practice_signs':
      'Practice your signs',

      'review_learned':
      'Review what you have learned',

      'start': 'Start',

      'motivation':
      'Every sign you learn is one more way to connect with the world.',

      'keep_learning':
      'Keep learning. Keep connecting.',

      'learner': 'Learner',
      'learner_profile':
      'Learner profile',

      'build_isl':
      'Build your ISL skills',
    },

    // ==========================================================
    // HINDI
    // ==========================================================

    'हिन्दी': {
      'home': 'होम',
      'learn': 'सीखें',
      'practice': 'अभ्यास',
      'profile': 'प्रोफ़ाइल',
      'settings': 'सेटिंग्स',
      'notifications': 'सूचनाएँ',

      'hello': 'नमस्ते',
      'ready_to_learn':
      'भारतीय सांकेतिक भाषा सीखने के लिए तैयार हैं?',

      'continue_learning':
      'सीखना जारी रखें',

      'view_all': 'सभी देखें',
      'greetings': 'अभिवादन',

      'continue_current_lesson':
      'अपना वर्तमान पाठ जारी रखें',

      'lesson_progress':
      'पाठ की प्रगति',

      'todays_goal':
      'आज का लक्ष्य',

      'daily_learning_goal':
      'दैनिक सीखने का लक्ष्य',

      'lesson_remaining':
      '1 पाठ बाकी',

      'learning_path':
      'आपकी सीखने की यात्रा',

      'beginner': 'शुरुआती',
      'intermediate': 'मध्यवर्ती',
      'advanced': 'उन्नत',

      'build_foundations':
      'अपनी बुनियाद मजबूत करें',

      'build_fluency':
      'प्रवाह और आत्मविश्वास बढ़ाएँ',

      'master_communication':
      'जटिल संचार में महारत हासिल करें',

      'current': 'वर्तमान',

      'practice_signs':
      'अपने संकेतों का अभ्यास करें',

      'review_learned':
      'जो सीखा है उसका अभ्यास करें',

      'start': 'शुरू करें',

      'motivation':
      'आपका सीखा हर संकेत दुनिया से जुड़ने का एक नया तरीका है।',

      'keep_learning':
      'सीखते रहें। जुड़े रहें।',

      'learner': 'शिक्षार्थी',

      'learner_profile':
      'शिक्षार्थी प्रोफ़ाइल',

      'build_isl':
      'अपने ISL कौशल को विकसित करें',
    },

    // ==========================================================
    // TAMIL
    // ==========================================================

    'தமிழ்': {
      'home': 'முகப்பு',
      'learn': 'கற்க',
      'practice': 'பயிற்சி',
      'profile': 'சுயவிவரம்',
      'settings': 'அமைப்புகள்',
      'notifications': 'அறிவிப்புகள்',

      'hello': 'வணக்கம்',

      'ready_to_learn':
      'இந்திய சைகை மொழியை கற்க தயாரா?',

      'continue_learning':
      'கற்றலைத் தொடருங்கள்',

      'view_all':
      'அனைத்தையும் காண்க',

      'greetings':
      'வாழ்த்துகள்',

      'continue_current_lesson':
      'உங்கள் தற்போதைய பாடத்தைத் தொடருங்கள்',

      'lesson_progress':
      'பாட முன்னேற்றம்',

      'todays_goal':
      'இன்றைய இலக்கு',

      'daily_learning_goal':
      'தினசரி கற்றல் இலக்கு',

      'lesson_remaining':
      '1 பாடம் மீதமுள்ளது',

      'learning_path':
      'உங்கள் கற்றல் பாதை',

      'beginner':
      'தொடக்கநிலை',

      'intermediate':
      'இடைநிலை',

      'advanced':
      'மேம்பட்ட நிலை',

      'build_foundations':
      'அடிப்படைகளை உருவாக்குங்கள்',

      'build_fluency':
      'சரளத்தையும் நம்பிக்கையையும் வளர்த்துக் கொள்ளுங்கள்',

      'master_communication':
      'சிக்கலான தொடர்புகளில் தேர்ச்சி பெறுங்கள்',

      'current':
      'தற்போதைய',

      'practice_signs':
      'உங்கள் சைகைகளைப் பயிற்சி செய்யுங்கள்',

      'review_learned':
      'நீங்கள் கற்றவற்றை மதிப்பாய்வு செய்யுங்கள்',

      'start':
      'தொடங்கு',

      'motivation':
      'நீங்கள் கற்கும் ஒவ்வொரு சைகையும் உலகத்துடன் இணைவதற்கான ஒரு புதிய வழியாகும்.',

      'keep_learning':
      'கற்றுக்கொண்டே இருங்கள். இணைந்திருங்கள்.',

      'learner':
      'கற்றவர்',

      'learner_profile':
      'கற்றவர் சுயவிவரம்',

      'build_isl':
      'உங்கள் ISL திறன்களை வளர்த்துக் கொள்ளுங்கள்',
    },

    // ==========================================================
    // TELUGU
    // ==========================================================

    'తెలుగు': {
      'home': 'హోమ్',
      'learn': 'నేర్చుకోండి',
      'practice': 'అభ్యాసం',
      'profile': 'ప్రొఫైల్',
      'settings': 'సెట్టింగ్స్',
      'notifications': 'నోటిఫికేషన్లు',

      'hello': 'నమస్కారం',

      'ready_to_learn':
      'ఇండియన్ సైన్ లాంగ్వేజ్ నేర్చుకోవడానికి సిద్ధంగా ఉన్నారా?',

      'continue_learning':
      'నేర్చుకోవడం కొనసాగించండి',

      'view_all':
      'అన్నీ చూడండి',

      'greetings':
      'శుభాకాంక్షలు',

      'continue_current_lesson':
      'మీ ప్రస్తుత పాఠాన్ని కొనసాగించండి',

      'lesson_progress':
      'పాఠం పురోగతి',

      'todays_goal':
      'ఈరోజు లక్ష్యం',

      'daily_learning_goal':
      'రోజువారీ అభ్యాస లక్ష్యం',

      'lesson_remaining':
      '1 పాఠం మిగిలి ఉంది',

      'learning_path':
      'మీ అభ్యాస మార్గం',

      'beginner':
      'ప్రారంభ స్థాయి',

      'intermediate':
      'మధ్యస్థ స్థాయి',

      'advanced':
      'అధునాతన స్థాయి',

      'build_foundations':
      'మీ ప్రాథమిక నైపుణ్యాలను పెంచుకోండి',

      'build_fluency':
      'ప్రవాహం మరియు ఆత్మవిశ్వాసాన్ని పెంచుకోండి',

      'master_communication':
      'సంక్లిష్ట కమ్యూనికేషన్‌లో నైపుణ్యం సాధించండి',

      'current':
      'ప్రస్తుత',

      'practice_signs':
      'మీ సంకేతాలను అభ్యసించండి',

      'review_learned':
      'మీరు నేర్చుకున్న వాటిని సమీక్షించండి',

      'start':
      'ప్రారంభించండి',

      'motivation':
      'మీరు నేర్చుకునే ప్రతి సంకేతం ప్రపంచంతో అనుసంధానానికి మరో మార్గం.',

      'keep_learning':
      'నేర్చుకుంటూ ఉండండి. అనుసంధానంగా ఉండండి.',

      'learner':
      'అభ్యాసకుడు',

      'learner_profile':
      'అభ్యాసకుడి ప్రొఫైల్',

      'build_isl':
      'మీ ISL నైపుణ్యాలను అభివృద్ధి చేసుకోండి',
    },

    // ==========================================================
    // KANNADA
    // ==========================================================

    'ಕನ್ನಡ': {
      'home': 'ಮುಖಪುಟ',
      'learn': 'ಕಲಿಯಿರಿ',
      'practice': 'ಅಭ್ಯಾಸ',
      'profile': 'ಪ್ರೊಫೈಲ್',
      'settings': 'ಸೆಟ್ಟಿಂಗ್ಸ್',
      'notifications': 'ಅಧಿಸೂಚನೆಗಳು',

      'hello': 'ನಮಸ್ಕಾರ',

      'ready_to_learn':
      'ಭಾರತೀಯ ಸಂಕೇತ ಭಾಷೆಯನ್ನು ಕಲಿಯಲು ಸಿದ್ಧರಿದ್ದೀರಾ?',

      'continue_learning':
      'ಕಲಿಕೆಯನ್ನು ಮುಂದುವರಿಸಿ',

      'view_all':
      'ಎಲ್ಲವನ್ನೂ ನೋಡಿ',

      'greetings':
      'ಶುಭಾಶಯಗಳು',

      'continue_current_lesson':
      'ನಿಮ್ಮ ಪ್ರಸ್ತುತ ಪಾಠವನ್ನು ಮುಂದುವರಿಸಿ',

      'lesson_progress':
      'ಪಾಠದ ಪ್ರಗತಿ',

      'todays_goal':
      'ಇಂದಿನ ಗುರಿ',

      'daily_learning_goal':
      'ದೈನಂದಿನ ಕಲಿಕೆಯ ಗುರಿ',

      'lesson_remaining':
      '1 ಪಾಠ ಬಾಕಿಯಿದೆ',

      'learning_path':
      'ನಿಮ್ಮ ಕಲಿಕೆಯ ಮಾರ್ಗ',

      'beginner':
      'ಆರಂಭಿಕ',

      'intermediate':
      'ಮಧ್ಯಮ',

      'advanced':
      'ಮುನ್ನಡೆದ',

      'build_foundations':
      'ನಿಮ್ಮ ಮೂಲಭೂತ ಕೌಶಲ್ಯಗಳನ್ನು ಬೆಳೆಸಿಕೊಳ್ಳಿ',

      'build_fluency':
      'ಸರಳತೆ ಮತ್ತು ಆತ್ಮವಿಶ್ವಾಸವನ್ನು ಬೆಳೆಸಿಕೊಳ್ಳಿ',

      'master_communication':
      'ಸಂಕೀರ್ಣ ಸಂವಹನದಲ್ಲಿ ಪರಿಣತಿ ಪಡೆಯಿರಿ',

      'current':
      'ಪ್ರಸ್ತುತ',

      'practice_signs':
      'ನಿಮ್ಮ ಸಂಕೇತಗಳನ್ನು ಅಭ್ಯಾಸ ಮಾಡಿ',

      'review_learned':
      'ನೀವು ಕಲಿತದ್ದನ್ನು ಪರಿಶೀಲಿಸಿ',

      'start':
      'ಪ್ರಾರಂಭಿಸಿ',

      'motivation':
      'ನೀವು ಕಲಿಯುವ ಪ್ರತಿಯೊಂದು ಸಂಕೇತವೂ ಜಗತ್ತಿನೊಂದಿಗೆ ಸಂಪರ್ಕ ಸಾಧಿಸಲು ಮತ್ತೊಂದು ಮಾರ್ಗವಾಗಿದೆ.',

      'keep_learning':
      'ಕಲಿಯುತ್ತಿರಿ. ಸಂಪರ್ಕದಲ್ಲಿರಿ.',

      'learner':
      'ಕಲಿಯುವವರು',

      'learner_profile':
      'ಕಲಿಯುವವರ ಪ್ರೊಫೈಲ್',

      'build_isl':
      'ನಿಮ್ಮ ISL ಕೌಶಲ್ಯಗಳನ್ನು ಬೆಳೆಸಿಕೊಳ್ಳಿ',
    },

    // ==========================================================
    // MALAYALAM
    // ==========================================================

    'മലയാളം': {
      'home': 'ഹോം',
      'learn': 'പഠിക്കുക',
      'practice': 'പരിശീലനം',
      'profile': 'പ്രൊഫൈൽ',
      'settings': 'ക്രമീകരണങ്ങൾ',
      'notifications': 'അറിയിപ്പുകൾ',

      'hello': 'നമസ്കാരം',

      'ready_to_learn':
      'ഇന്ത്യൻ സൈൻ ലാംഗ്വേജ് പഠിക്കാൻ തയ്യാറാണോ?',

      'continue_learning':
      'പഠനം തുടരുക',

      'view_all':
      'എല്ലാം കാണുക',

      'greetings':
      'ആശംസകൾ',

      'continue_current_lesson':
      'നിങ്ങളുടെ നിലവിലെ പാഠം തുടരുക',

      'lesson_progress':
      'പാഠ പുരോഗതി',

      'todays_goal':
      'ഇന്നത്തെ ലക്ഷ്യം',

      'daily_learning_goal':
      'ദൈനംദിന പഠന ലക്ഷ്യം',

      'lesson_remaining':
      '1 പാഠം ബാക്കി',

      'learning_path':
      'നിങ്ങളുടെ പഠന പാത',

      'beginner':
      'തുടക്കക്കാരൻ',

      'intermediate':
      'ഇടത്തരം',

      'advanced':
      'മുന്നേറിയ',

      'build_foundations':
      'അടിസ്ഥാന കഴിവുകൾ വികസിപ്പിക്കുക',

      'build_fluency':
      'പ്രാവീണ്യവും ആത്മവിശ്വാസവും വളർത്തുക',

      'master_communication':
      'സങ്കീർണ്ണ ആശയവിനിമയത്തിൽ പ്രാവീണ്യം നേടുക',

      'current':
      'നിലവിലെ',

      'practice_signs':
      'നിങ്ങളുടെ സൈൻ പരിശീലിക്കുക',

      'review_learned':
      'നിങ്ങൾ പഠിച്ച കാര്യങ്ങൾ ആവർത്തിക്കുക',

      'start':
      'ആരംഭിക്കുക',

      'motivation':
      'നിങ്ങൾ പഠിക്കുന്ന ഓരോ സൈനും ലോകവുമായി ബന്ധപ്പെടാനുള്ള മറ്റൊരു വഴിയാണ്.',

      'keep_learning':
      'പഠിച്ചുകൊണ്ടിരിക്കുക. ബന്ധപ്പെട്ടു കൊണ്ടിരിക്കുക.',

      'learner':
      'പഠിതാവ്',

      'learner_profile':
      'പഠിതാവിന്റെ പ്രൊഫൈൽ',

      'build_isl':
      'നിങ്ങളുടെ ISL കഴിവുകൾ വികസിപ്പിക്കുക',
    },
  };
}