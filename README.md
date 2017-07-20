# FluentExtended
[![Build Status](https://travis-ci.org/cardoso/fluent-extended.svg?branch=master)](https://travis-ci.org/cardoso/fluent-extended)
[![Coverage Status](https://coveralls.io/repos/github/cardoso/fluent-extended/badge.svg?branch=master)](https://coveralls.io/github/cardoso/fluent-extended?branch=master)

Handy extensions for [Fluent](https://github.com/vapor/fluent)

# Features

### Filter <-> Node

Filters can be converted to and from Node, allowing filters to be constructed from JSON and other formats

This allows for easily adding powerful filtering mechanism in resource routes:

#### Usage:

```swift
/// [GET] @ /users
/// Returns all users, optionally filtered by the request data.
func index(_ req: Request) throws -> ResponseRepresentable {
    if let filterString = req.query?["filter"]?.string {
        let filterJSON = try JSON(bytes: filterString.data(using: .utf8)?.makeBytes() ?? [])
        let filter = try Filter(User.self, Node(filterJSON))
        return try User.makeQuery().filter(filter).all().makeJSON()
    }

    return try User.all().makeJSON()
}
```

request:
```json
/users?filter={"type":"group","relation":"or","filters":[{"type":"subset","field":"username","scope":"in","values":["admin","edvaldo"]},{"type":"compare","field":"id","comparison":"greaterThan","value":3}]}
```

response:
```json
[
  {
    "id": 1,
    "username": "admin",
    "password": "123456"
  },
  {
    "id": 2,
    "username": "edvaldo",
    "password": "54984b30b129d24955660429ff62b336bbee8711107f741b686fda8f0f31b140"
  },
  {
    "id": 4,
    "username": "matheusmcardoso",
    "password": "54984b30b129d24955660429ff62b336bbee8711107f741b686fda8f0f31b140"
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
