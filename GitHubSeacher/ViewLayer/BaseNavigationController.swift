//
//  BaseNavigationController.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: private
    
    private func setupUI() {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationBar.tintColor = UIColor(red: 244.0 / 255.0, green: 147.0 / 255.0, blue: 11.0 / 255.0, alpha: 1.0)
        navigationBar.barTintColor = UIColor(white: 16.0 / 255.0, alpha: 1.0)
        navigationBar.isTranslucent = false
    }
}
