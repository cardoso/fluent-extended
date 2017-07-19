@testable import FluentExtended

import XCTest
import Fluent
import Node

class FilterPlusNodeTest: XCTestCase {
    
    static var allTests = [
        ("testInitAndMakeNode", testInitAndMakeNode),
        ("testCustomFromString", testCustomFromString)
    ]
    
    static func makeCompare() -> Filter {
        return Filter(TestEntity.self, .compare("string0", .equals, "string0"))
    }
    
    static func makeCompareNode() throws -> Node {
        var compare = Node([:])
        try compare.set("type", "compare")
        try compare.set("field", "string0")
        try compare.set("comparison", "equals")
        try compare.set("value", "string0")
        return compare
    }
    
    static func makeSubset() -> Filter {
        return Filter(TestEntity.self, .subset("string0", .in, ["string0", "string1"]))
    }
    
    static func makeSubsetNode() throws -> Node {
        var subset = Node([:])
        try subset.set("type", "subset")
        try subset.set("field", "string0")
        try subset.set("scope", "in")
        try subset.set("values", ["string0", "string1"])
        return subset
    }
    
    static func makeGroup() -> Filter {
        return Filter(TestEntity.self, .group(.and, [RawOr.some(makeCompare()), RawOr.some(makeSubset())]))
    }
    
    static func makeGroupNode() throws -> Node {
        var group = Node([:])
        try group.set("type", "group")
        try group.set("relation", "and")
        try group.set("filters", [makeCompare(), makeSubset()])
        return group
    }
    
    func testInitAndMakeNode() throws {
        
        let _compare = try FilterPlusNodeTest.makeCompareNode()
        let compare = FilterPlusNodeTest.makeCompare()
        
        XCTAssert(try compare.makeNode(in: nil) == _compare)
        
        switch(compare.method) {
        case .compare(let field, let comparison, let value):
            XCTAssert(field == "string0")
            XCTAssert(comparison == .equals)
            XCTAssert(value.string == "string0")
        default:
            XCTFail()
        }
        
        let _subset = try FilterPlusNodeTest.makeSubsetNode()
        let subset = FilterPlusNodeTest.makeSubset()
        
        XCTAssert(try subset.makeNode(in: nil) == _subset)
        
        switch(subset.method) {
        case .subset(let field, let scope, let values):
            XCTAssert(field == "string0")
            XCTAssert(scope == .in)
            XCTAssert(values == ["string0", "string1"])
        default:
            XCTFail()
        }
        
        let _group = try FilterPlusNodeTest.makeGroupNode()
        let group = FilterPlusNodeTest.makeGroup()
        
        XCTAssert(try group.makeNode(in: nil) == _group)
        
        switch(group.method) {
        case .group(let relation, let filters):
            XCTAssert(relation == .and)
            XCTAssert(filters == [RawOr.some(compare), RawOr.some(subset)])
        default:
            XCTFail()
        }
    }
    
    func testCustomFromString() {
        XCTAssert(try Filter.Comparison.customFromString("custom(test)") == .custom("test"))
    }
}
