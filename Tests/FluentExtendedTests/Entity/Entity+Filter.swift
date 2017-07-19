@testable import FluentExtended

import XCTest
import Fluent


class EntityPlusFilterTest: XCTestCase {
    
    static var allTests = [
        ("testEntityAll", testEntityAll),
        ("testEntityFirst", testEntityFirst)
    ]
    
    var database: Database!
    override func setUp() {
        do {
            database = try Database(MemoryDriver())
            try TestEntity.prepare(database)
        } catch {
            XCTFail("Test setup failed")
        }
    }
    
    func testEntityAll() throws {
        
        let test = TestEntity()
        test.string1 = "same"
        try test.save()
        
        let test2 = TestEntity()
        test2.string1 = "same"
        try test2.save()
        
        let test3 = TestEntity()
        test2.string1 = "different"
        try test3.save()
        
        let tests = try TestEntity.all(with: ("string1", .equals, "same"))
        
        XCTAssertEqual(tests.count, 2)
    }
    
    func testEntityFirst() throws {
        let test = TestEntity()
        test.int0 = 0
        test.string1 = "same"
        try test.save()
        
        let test2 = TestEntity()
        test2.int0 = 1
        test2.string1 = "same"
        try test2.save()
        
        let entity = try TestEntity.first(with: ("string1", .equals, "same"))
        
        XCTAssertEqual(entity?.int0, 0)
    }
}
