
import 'lang/lang.dart';

String currentLang = 'en_us';

List<String> availableLangs = List.from(languages.keys);
Lang lang = Lang(lang: 'en_us');
Lang usLang = Lang(lang: 'en_us');

getString(String k,[List p = const []])=>lang.contains(k)? lang.getString(k, p) : usLang.getString(k, p);