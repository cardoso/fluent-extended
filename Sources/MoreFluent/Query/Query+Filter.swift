import Fluent

extension Query {
    
    /// Filter self for each filter where field equals value
    public func filter(
        _ filters: [(field: String, value: NodeRepresentable?)]
        ) throws -> Query<E> {
        var query = self
        try filters.forEach {
            query = try query.filter($0.field, $0.value)
        }
        return query
    }
}
