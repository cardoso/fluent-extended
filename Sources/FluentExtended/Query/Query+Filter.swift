import Fluent

extension Query {
    
    /// Filter self for each filter where field equals value
    public func filter(
        _ filters: [FilterTuple]
        ) throws -> Query<E> {
        var query = self
        try filters.forEach {
            query = try query.filter($0.field, $0.comparison, $0.value)
        }
        return query
    }
    
    public func filter(
        _ filters: FilterTuple...
        ) throws -> Query<E> {
        return try filter(filters)
    }
}
