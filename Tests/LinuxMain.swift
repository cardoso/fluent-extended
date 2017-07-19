import XCTest

@testable import FluentExtendedTests

XCTMain([
    testCase(QueryPlusFilterTest.allTests),
    testCase(EntityPlusFilterTest.allTests)
    ])
