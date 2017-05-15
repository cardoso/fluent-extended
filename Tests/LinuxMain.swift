//
//  LinuxMain.swift
//  more-fluent
//
//  Created by Matheus Martins on 5/15/17.
//
//

import XCTest

@testable import MoreFluentTests

XCTMain([
    testCase(QueryPlusFilterTest.allTests),
    testCase(EntityPlusFilterTest.allTests)
    ])
