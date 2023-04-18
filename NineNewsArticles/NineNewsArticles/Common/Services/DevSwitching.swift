//
//  DevSwitching.swift
//  NineNewsArticles
//
//  Created by Abdullah Alashi on 12/4/2023.
//

import Foundation

public protocol DevSwitching {

    var publicRelease: Bool { get }
    var releaseCasuMarzu: Bool { get }
}

final class DevSwitch: DevSwitching {
    @Switch(key: "publicRelease", defaultValue: false)
    private(set) var publicRelease: Bool

    @Switch(key: "releaseCasuMarzu", defaultValue: false)
    private(set) var releaseCasuMarzu: Bool
}

// MARK: - Models

extension DevSwitch {

    @propertyWrapper
    struct Switch {

        let key: String
        let defaultValue: Bool
        let container: UserDefaults = .standard

        var wrappedValue: Bool {
            get {
                guard !container.value(forKey: fullKey(for: key)).isNil else {
                    return defaultValue
                }

                return container.bool(forKey: fullKey(for: key))
            }
            set {
                container.set(newValue, forKey: fullKey(for: key))
            }
        }

        private func fullKey(for key: String) -> String {
            return "setting.devSwitch.\(key)"
        }
    }
}
