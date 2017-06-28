import Fluent

extension Entity {
    
    /// Returns all entities for this `Entity` passing the filters
    public static func all(
        with filters: [MoreFilter]
        ) throws -> [Self] {
        return try makeQuery().filter(filters).all()
    }
    
    public static func all(
        with filters: MoreFilter...
        ) throws -> [Self] {
        return try all(with: filters)
    }
    
    /// Returns the first entity for this `Entity` passing the filters
    public static func first(
        with filters: [MoreFilter]
        ) throws -> Self? {
        return try all(with: filters).first
    }
    
    public static func first(
        with filters: MoreFilter...
        ) throws -> Self? {
        return try first(with: filters)
    }
}
