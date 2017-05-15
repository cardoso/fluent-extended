@testable import MoreFluent

import XCTest
import Fluent


class QueryPlusFilterTest: XCTestCase {
    
    var database: Database!
    override func setUp() {
        do {
            database = try Database(MemoryDriver())
            try TestEntity.prepare(database)
        } catch {
            XCTFail("Test setup failed")
        }
    }
    
    func testQueryFilter() throws {
        
        let test = TestEntity()
        test.string1 = "test"
        try test.save()
        
        let test2 = TestEntity()
        test2.string1 = "test2"
        try test2.save()
        
        let query = try TestEntity.makeQuery().filter([("string1", "test"),
                                                       ("int0", 0)])
        
        XCTAssertEqual(try query.count(), 1)
    }
}
