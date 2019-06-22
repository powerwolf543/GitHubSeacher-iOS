//
//  PaginationResponse.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import Foundation

struct PaginationResponse<T> {
    let currentPage: UInt
    let hasMore: Bool
    let dataModel: T
}
