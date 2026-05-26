import Foundation

enum AppLocale {
    static var appLocale: Locale {
        Locale(identifier: appLanguageIdentifier)
    }

    static var appLanguageIdentifier: String {
        if let language = ProcessInfo.processInfo.environment["UITEST_LANGUAGE"], !language.isEmpty {
            return language
        }

        return Locale.current.region?.identifier == "CN" ? "zh-Hans" : "en"
    }

    static var isChinaRegion: Bool {
        appLanguageIdentifier == "zh-Hans" || Locale.current.region?.identifier == "CN"
    }

    static var privacyURL: URL {
        localizedPage(named: "privacy")
    }

    static var supportURL: URL {
        localizedPage(named: "support")
    }

    private static func localizedPage(named page: String) -> URL {
        let prefix = "https://davidzyj.github.io/trip-journal-app"
        let path = isChinaRegion ? "/zh/\(page).html" : "/\(page).html"
        return URL(string: prefix + path)!
    }
}
