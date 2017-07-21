@testable import FluentExtended

import XCTest
import Fluent
import Node

class FilterPlusNodeTest: XCTestCase {
    
    static var allTests = [
        ("testCompare", testCompare),
        ("testSubset", testSubset),
        ("testCustomFromString", testCustomFromString)
    ]
    
    static func makeCompare() throws -> Node {
        var compare = Node([:])
        try compare.set("entity", "FluentExtendedTests.TestEntity")
        var method = Node([:])
        try method.set("type", "compare")
        try method.set("field", "string0")
        try method.set("comparison", "equals")
        try method.set("value", "string0")
        try compare.set("method", method)
        return compare
    }
    
    static func makeSubset() throws -> Node {
        var subset = Node([:])
        try subset.set("entity", "FluentExtendedTests.TestEntity")
        var method = Node([:])
        try method.set("type", "subset")
        try method.set("field", "string0")
        try method.set("scope", "in")
        try method.set("values", ["string0", "string1"])
        try subset.set("method", method)
        return subset
    }
    
    static func makeGroup() throws -> Node {
        var group = Node([:])
        try group.set("entity", "FluentExtendedTests.TestEntity")
        var method = Node([:])
        try method.set("type", "group")
        try method.set("relation", "and")
        try method.set("filters", [makeCompare(), makeSubset()])
        try group.set("method", method)
        return group
    }
    
    func testCompare() throws {
        let _compare = try FilterPlusNodeTest.makeCompare()
        let compare = try Filter(node: _compare)
        print(try compare.makeNode(in: nil))
        XCTAssert(try compare.makeNode(in: nil) == _compare)

        switch(compare.method) {
        case .compare(let field, let comparison, let value):
            XCTAssert(field == "string0")
            XCTAssert(comparison == .equals)
            XCTAssert(value.string == "string0")
        default:
            XCTFail()
        }
    }

    func testSubset() throws {
        let _subset = try FilterPlusNodeTest.makeSubset()
        let subset = try Filter(node: _subset)

        XCTAssert(try subset.makeNode(in: nil) == _subset)

        switch(subset.method) {
        case .subset(let field, let scope, let values):
            XCTAssert(field == "string0")
            XCTAssert(scope == .in)
            XCTAssert(values == ["string0", "string1"])
        default:
            XCTFail()
        }
    }

    func testGroup() throws {
        let _group = try FilterPlusNodeTest.makeGroup()
        let group = try Filter(node: _group)

        XCTAssert(try group.makeNode(in: nil) == _group)

        let _compare = try FilterPlusNodeTest.makeCompare()
        let _subset = try FilterPlusNodeTest.makeSubset()

        switch(group.method) {
        case .group(let relation, let filters):
            XCTAssert(relation == .and)
            XCTAssert(try filters.map { $0.wrapped! }.map { try $0.makeNode(in: nil) } == [_compare, _subset])
        default:
            XCTFail()
        }
    }

    func testCustomFromString() {
        XCTAssert(try Filter.Comparison.customFromString("custom(test)") == .custom("test"))
    }
}
