//
//  UIStoryboardExtensions.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import UIKit

extension UIStoryboard {

    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T {
        return instantiateViewController(withIdentifier: String(describing: name)) as! T
    }
    
}
