//
//  InputViewController.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import UIKit

class InputViewController: BaseViewController {
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: Click event
    
    @IBAction func searchButtonDidPressed(_ sender: UIButton) {
        searchTextField.resignFirstResponder()
        let vc = storyboard!.instantiateViewController(withClass: SearchViewController.self)
        vc.presenter.query = searchTextField.text ?? ""
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: UI
    
    @IBOutlet weak var searchTextField: UITextField!
    
    private func setupUI() {
        navigationItem.title = "GitHub"
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [.foregroundColor: UIColor(white: 141.0 / 255.0, alpha: 1.0)])
        searchTextField.delegate = self
    }
    
}

extension InputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
