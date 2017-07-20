import Fluent
import Node

extension Filter: NodeRepresentable {
    public init(_ entity: Entity.Type, _ node: Node) throws {
        self.method = try Method(entity, node)
        self.entity = entity
    }
    
    public func makeNode(in context: Context?) throws -> Node {
        return try self.method.makeNode(in: context)
    }
}

enum FilterSerializationError: Error {
    case undefinedComparison(String)
    case undefinedScope(String)
    case undefinedRelation(String)
    case undefinedMethodType(String)
}

extension Filter.Comparison {
    public var string: String {
        switch(self) {
        case .equals: return "equals"
        case .greaterThan: return "greaterThan"
        case .lessThan: return "lessThan"
        case .greaterThanOrEquals: return "greaterThanOrEquals"
        case .lessThanOrEquals: return "lessThanOrEquals"
        case .notEquals: return "notEquals"
        case .hasSuffix: return "hasSuffix"
        case .hasPrefix: return "hasPrefix"
        case .contains: return "contains"
        case .custom(let s): return "custom(\(s))"
        }
    }
    
    static func customFromString(_ string: String) throws -> Filter.Comparison {
        guard string.hasPrefix("custom(") && string.hasSuffix(")") else {
            throw FilterSerializationError.undefinedComparison(string)
        }
        let start = string.index(string.startIndex, offsetBy: 7)
        let end = string.index(string.endIndex, offsetBy: -1)
        return .custom(string.substring(with: start..<end))
    }
    
    public init(_ string: String) throws {
        switch(string) {
        case "equals": self = .equals
        case "greaterThan": self = .greaterThan
        case "lessThan": self = .lessThan
        case "greaterThanOrEquals": self = .greaterThanOrEquals
        case "lessThanOrEquals": self = .lessThanOrEquals
        case "notEquals": self = .notEquals
        case "hasSuffix": self = .hasSuffix
        case "hasPrefix": self = .hasPrefix
        case "contains": self = .contains
        default: self = try .customFromString(string)
        }
    }
}

extension Filter.Scope {
    public var string: String {
        switch(self) {
        case .`in`: return "in"
        case .notIn: return "notIn"
        }
    }
    
    public init(_ string: String) throws {
        switch(string) {
        case "in": self = .`in`
        case "notIn": self = .notIn
        default: throw FilterSerializationError.undefinedScope(string)
        }
    }
}

extension Filter.Relation {
    public var string: String {
        switch(self) {
        case .and: return "and"
        case .or: return "or"
        }
    }
    
    public init(_ string: String) throws {
        switch(string) {
        case "and": self = .and
        case "or": self = .or
        default: throw FilterSerializationError.undefinedRelation(string)
        }
    }
}

extension Filter.Method: NodeRepresentable {
    var string: String {
        switch self {
        case .compare(_, _, _): return "compare"
        case .subset(_, _, _): return "subset"
        case .group(_, _): return "group"
        }
    }
    
    public init(_ entity: Entity.Type, _ node: Node) throws {
        let type: String = try node.get("type")
        
        if(type == "compare") {
            let field: String = try node.get("field")
            let comparison = try Filter.Comparison(try node.get("comparison"))
            let value: Node = try node.get("value")
            
            self = .compare(field, comparison, value); return
        }
        
        if(type == "subset") {
            let field: String = try node.get("field")
            let scope = try Filter.Scope(try node.get("scope"))
            let values: [Node] = try node.get("values")
            print(values)
            self = .subset(field, scope, values); return
        }
        
        if(type == "group") {
            let relation = try Filter.Relation(try node.get("relation"))
            let filters = try (try node.get("filters") as [Node]).map {
                RawOr<Filter>.some(try Filter(entity, $0))
            }
            
            self = .group(relation, filters); return
        }
        
        throw FilterSerializationError.undefinedMethodType(type)
    }
    
    public func makeNode(in context: Context?) throws -> Node {
        var node = Node([:])
        try node.set("type", self.string)
        
        if case .compare(let field, let comparison, let value) = self {
            try node.set("field", field)
            try node.set("comparison", comparison.string)
            try node.set("value", value)
        }
        
        if case .subset(let field, let scope, let values) = self {
            try node.set("field", field)
            try node.set("scope", scope.string)
            try node.set("values", values)
        }
        
        if case .group(let relation, let filters) = self {
            try node.set("relation", relation.string)
            try node.set("filters", filters.map { $0.wrapped })
        }
        
        return node
    }
}
