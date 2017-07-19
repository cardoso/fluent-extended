import Fluent

class TestEntity: Entity {
    
    let storage = Storage()
    
    var string0 = "field0"
    var string1 = "field1"
    var int0 = 0
    var int1 = 1
    
    init() {
        
    }
    
    required init(row: Row) throws {
        string0 = try row.get("string0")
        string1 = try row.get("string1")
        int0 = try row.get("int0")
        int1 = try row.get("int1")
    }
    
    func makeRow() throws -> Row {
        var row = Row()
        try row.set("id", self.id)
        try row.set("string0", string0)
        try row.set("string1", string1)
        try row.set("int0", int0)
        try row.set("int1", int1)
        return row
    }
}

extension TestEntity: Preparation {
    
    static func prepare(_ database: Database) throws {
        try database.create(self) { c in
            c.id()
            c.string("string0")
            c.string("string1")
            c.int("int0")
            c.int("int1")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}
