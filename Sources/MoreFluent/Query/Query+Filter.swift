import Fluent

public typealias QueryFilter = (field: String, value: NodeRepresentable?)

extension Query {
    
    /// Filter self for each filter where field equals value
    public func filter(
        _ filters: [QueryFilter]
        ) throws -> Query<E> {
        var query = self
        try filters.forEach {
            query = try query.filter($0.field, $0.value)
        }
        return query
    }
}
