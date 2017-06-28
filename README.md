# MoreFluent
[![Build Status](https://travis-ci.org/cardoso/more-fluent.svg?branch=master)](https://travis-ci.org/cardoso/more-fluent)
[![Code Coverage](https://codecov.io/gh/cardoso/more-fluent/branch/master/graph/badge.svg)](https://codecov.io/gh/cardoso/more-fluent)

Handy extensions for [Fluent](https://github.com/vapor/fluent)

# Features
### Cleaner lazy lookups with multiple filters

Fluent:
```swift
Book.makeQuery().filter("genre", "scifi")
                .filter("target", "children")
                .filter("language", "en")
```

MoreFluent:
```swift
Book.makeQuery().filter([("genre", "scifi"),
                         ("target", "children"),
                         ("language", "en")])
```
### Active lookups
Fluent:
```swift
Book.makeQuery().filter("genre", "scifi")
                .filter("target", "children")
                .filter("language", "en")
                .all()
```
```swift
Book.makeQuery().filter("genre", "scifi")
                .filter("target", "children")
                .filter("language", "en")
                .first()
```

MoreFluent:
```swift
Book.all(with: [("genre", "scifi"),
                ("target", "children"),
                ("language", "en")])
```
```swift
Book.first(with: [("genre", "scifi"),
                  ("target", "children"),
                  ("language", "en")])
```
