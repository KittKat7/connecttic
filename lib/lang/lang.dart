import './en_us.dart' as en_us show lang;
import './lolcat.dart' as lolcat show lang;

Map<String, dynamic> languages = {
	'en_us': en_us.lang,
	'lolcat': lolcat.lang,
};

const String githubSite = 'https://github.com/KittKat7/ConnectTic';

class Lang {
	Map<String, String> langMap;
	Lang({required String lang}) : langMap = languages[lang];

	void setLang(String lang) {
		langMap = languages[lang];
	}

	String getString(String key, [List params = const []]) {
		String str = langMap[key]!;
		for (int i = 0; i < params.length; i++) {
			str = str.replaceAll('\${$i}', params[i]);
		}
		// for (String key in params.keys) {
		// 	str.replaceAll('\${key}', params[key]);
		// }
		return str;
	}

	bool contains(String key) {
		return langMap.containsKey(key);
	}

	String concat(List<String> strs) {
		String str = '';
		for (int i = 0; i < strs.length; i++) {
			str += strs[i];
			if (i < strs.length - 1) {
				str += '\n';
			}
		}
		return str;
	}
}