//
//  DevSwitchingTests.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Alashi on 12/4/2023.
//

@testable import NineNewsArticles
import XCTest

final class DevSwitchingTests: XCTestCase {

    // MARK: - Properties

    private let devSwitch: DevSwitch = DevSwitch.shared
    private lazy var switches: [TestData] = [
        .init(key: "mock", defaultValue: false, keyPath: \.mock),
    ]

    // MARK: - Tests

    func testDevSwitches() {
        let userDefaults: UserDefaults = .standard

        switches.forEach {
            let key: String = "setting.\($0.key)"

            userDefaults.set(false, forKey: key)

            XCTAssertFalse(devSwitch[keyPath: $0.keyPath])

            userDefaults.set(true, forKey: key)

            XCTAssertTrue(devSwitch[keyPath: $0.keyPath])

            userDefaults.removeObject(forKey: key)

            XCTAssertEqual(devSwitch[keyPath: $0.keyPath], $0.defaultValue)
        }
    }
}

// MARK: - Models

private extension DevSwitchingTests {

    struct TestData {
        let key: String
        let defaultValue: Bool
        let keyPath: KeyPath<DevSwitch, Bool>
    }
}
