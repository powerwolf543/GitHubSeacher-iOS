//
//  UserModel.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import Foundation

struct UserModel: Codable {
    
    let accountName: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case accountName = "login"
        case imageURL = "avatar_url"
    }
}
