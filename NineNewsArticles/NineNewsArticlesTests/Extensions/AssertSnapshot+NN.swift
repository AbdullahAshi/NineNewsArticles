//
//  AssertSnapshot+NN.swift
//  NineNewsArticlesTests
//
//  Created by Abdullah Alashi on 24/3/2023.
//

import XCTest
import SnapshotTesting

/// Asserts that a given value matches a reference on disk.
///
/// - Parameters:
///   - vc: A UIViewController to compare against a reference.
///   - device: Device to test on
///   - precision: Precision to test to
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - failNewSnapshots: If newly recorded snapshots should fail
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
public func assertVCSnapshot(
  _ vc: @autoclosure () throws -> UIViewController,
  as snapshotting: Snapshotting<UIViewController, UIImage> = .image(on: .iPhoneX, precision: 0.95),
  named name: String? = nil,
  record recording: Bool = false,
  failNewSnapshots: Bool = false,
  timeout: TimeInterval = 5,
  file: StaticString = #file,
  testName: String = #function,
  line: UInt = #line,
  waitDuration: TimeInterval = 0
) {
  let failure = verifySnapshot(
    matching: try vc(),
    as: .wait(for: waitDuration, on: snapshotting),
    named: name,
    record: recording,
    timeout: timeout,
    file: file,
    testName: testName,
    line: line
  )
  
  assertFailure(failure, file: file, line: line, failNewSnapshots: failNewSnapshots)
}

/// Asserts that a given view matches a reference on disk.
///
/// - Parameters:
///   - view: A UIView to compare against a reference.
///   - precision: Precision to test to
///   - name: An optional description of the snapshot.
///   - recording: Whether or not to record a new reference.
///   - failNewSnapshots: If newly recorded snapshots should fail
///   - timeout: The amount of time a snapshot must be generated in.
///   - file: The file in which failure occurred. Defaults to the file name of the test case in which this function was called.
///   - testName: The name of the test in which failure occurred. Defaults to the function name of the test case in which this function was called.
///   - line: The line number on which failure occurred. Defaults to the line number on which this function was called.
///   - waitDuration: The amount of time to wait before taking the snapshot.
public func assertViewSnapshot(
  _ view: @autoclosure () throws -> UIView,
  with precision: Float = 0.95,
  named name: String? = nil,
  record recording: Bool = false,
  failNewSnapshots: Bool = false,
  timeout: TimeInterval = 5,
  file: StaticString = #file,
  testName: String = #function,
  line: UInt = #line,
  waitDuration: TimeInterval = 0
) {
  let failure = verifySnapshot(
    matching: try view(),
    as: .wait(for: waitDuration, on: .image(precision: precision)),
    named: name,
    record: recording,
    timeout: timeout,
    file: file,
    testName: testName,
    line: line
  )
  
  assertFailure(failure, file: file, line: line, failNewSnapshots: failNewSnapshots)
}

private func assertFailure(_ failure: String?, file: StaticString, line: UInt, failNewSnapshots: Bool) {
  guard let message = failure else { return }
  if !failNewSnapshots, message.contains("No reference was found on disk. Automatically recorded snapshot") {
    XCTAssert(true, message, file: file, line: line)
    return
  }
  XCTFail(message, file: file, line: line)
}
