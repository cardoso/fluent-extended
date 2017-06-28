import Fluent

public typealias MoreFilter = (field: String, comparison: Filter.Comparison, value: NodeRepresentable?)

extension Query {
    
    /// Filter self for each filter where field equals value
    public func filter(
        _ filters: [MoreFilter]
        ) throws -> Query<E> {
        var query = self
        try filters.forEach {
            query = try query.filter($0.field, $0.comparison, $0.value)
        }
        return query
    }
    
    public func filter(
        _ filters: MoreFilter...
        ) throws -> Query<E> {
        return try filter(filters)
    }
}
