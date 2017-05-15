import Fluent

extension Entity {
    
    /// Returns all entities for this `Model` passing the filters
    public static func all(
        with filters: [(field: String, value: NodeRepresentable?)]
        ) throws -> [Self] {
        return try makeQuery().filter(filters).all()
    }
    
    /// Returns the first entity for this `Model` passing the filters
    public static func first(
        with filters: [(field: String, value: NodeRepresentable?)]
        ) throws -> Self? {
        return try all(with: filters).first
    }
}
