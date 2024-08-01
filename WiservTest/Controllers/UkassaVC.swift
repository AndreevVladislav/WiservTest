//
//  UkassaVC.swift
//  WiservTest
//
//  Created by Vladislav Andreev on 01.08.2024.
//

import Foundation
import UIKit

class UkassaVC: UIViewController{
    
    private let text: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        text.text = "Здесь могла быть ваша реклама"
        text.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        text.textAlignment = .center
        text.numberOfLines = 0
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(text)
        
        setConstrains()
        
    }
    
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            
            text.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            text.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            text.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

