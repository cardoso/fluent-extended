# FluentExtended
[![Build Status](https://travis-ci.org/cardoso/fluent-extended.svg?branch=master)](https://travis-ci.org/cardoso/fluent-extended)
[![Coverage Status](https://codecov.io/gh/cardoso/fluent-extended/branch/master/graph/badge.svg)](https://codecov.io/gh/cardoso/fluent-extended/branch/master/)

Handy extensions for [Fluent](https://github.com/vapor/fluent)

# Features

### Filter <-> Node

Filters can be converted to and from Node, allowing filters to be constructed from JSON and other formats

This allows for easily adding powerful filtering mechanism in resource routes:

#### Usage:

##### route
```swift
/// [GET] @ /users
/// Returns all users, optionally filtered by the request data.
func index(_ req: Request) throws -> ResponseRepresentable {
    if let filterString = req.query?["filter"]?.string {
        let filterJSON = try JSON(bytes: filterString.data(using: .utf8)?.makeBytes() ?? [])
        let filter = try Filter(node: Node(filterJSON))
        return try User.makeQuery().filter(filter).all().makeJSON()
    }
    
    return try User.all().makeJSON()
}
```

##### request
```json
[GET]  /users?filter={"entity":"StalkrCloud.User","method":{"type":"compare","comparison":"equals", "field":"username","value":"admin"}}
```

##### response
```json
[
  {
    "id": 1,
    "username": "admin",
    "password": "123456"
  }
]
```

### Multiple Filters per Call

This avoids chaining of the filter method which adds noise to the code

```swift
Book.makeQuery().filter(("genre", .equals ,"scifi"),
                        ("target", .equals, "children"),
                        ("language", .equals, "en"))
```

```swift
Book.all(with: ("genre", .equals, "scifi"),
               ("target", .equals, "children"),
               ("language", .equals, "en"))
```

```swift
Book.first(with: ("genre", .equals, "scifi"),
                 ("target", .equals, "children"),
                 ("language", .equals, "en"))
```
