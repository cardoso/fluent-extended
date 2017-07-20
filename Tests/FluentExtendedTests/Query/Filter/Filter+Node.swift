@testable import FluentExtended

import XCTest
import Fluent
import Node

class FilterPlusNodeTest: XCTestCase {
    
    static var allTests = [
        ("testInitAndMakeNode", testInitAndMakeNode),
        ("testCustomFromString", testCustomFromString)
    ]
    
    static func makeCompare() throws -> Node {
        var compare = Node([:])
        try compare.set("type", "compare")
        try compare.set("field", "string0")
        try compare.set("comparison", "equals")
        try compare.set("value", "string0")
        return compare
    }
    
    static func makeSubset() throws -> Node {
        var subset = Node([:])
        try subset.set("type", "subset")
        try subset.set("field", "string0")
        try subset.set("scope", "in")
        try subset.set("values", ["string0", "string1"])
        return subset
    }
    
    static func makeGroup() throws -> Node {
        var group = Node([:])
        try group.set("type", "group")
        try group.set("relation", "and")
        try group.set("filters", [makeCompare(), makeSubset()])
        return group
    }
    
    func testInitAndMakeNode() throws {
        
        let _compare = try FilterPlusNodeTest.makeCompare()
        let compare = try Filter(TestEntity.self, _compare)
        
        XCTAssert(try compare.makeNode(in: nil) == _compare)

        switch(compare.method) {
        case .compare(let field, let comparison, let value):
            XCTAssert(field == "string0")
            XCTAssert(comparison == .equals)
            XCTAssert(value.string == "string0")
        default:
            XCTFail()
        }
        
        let _subset = try FilterPlusNodeTest.makeSubset()
        let subset = try Filter(TestEntity.self, _subset)
        
        XCTAssert(try subset.makeNode(in: nil) == _subset)
        
        switch(subset.method) {
        case .subset(let field, let scope, let values):
            XCTAssert(field == "string0")
            XCTAssert(scope == .in)
            XCTAssert(values == ["string0", "string1"])
        default:
            XCTFail()
        }
        
        let _group = try FilterPlusNodeTest.makeGroup()
        let group = try Filter(TestEntity.self, _group)
        
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
