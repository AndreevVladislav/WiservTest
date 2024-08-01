//
//  TextFieldModels.swift
//  WiservTest
//
//  Created by Vladislav Andreev on 30.07.2024.
//

import UIKit

class CustomTextField: UITextField, UITextFieldDelegate {

    private let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        
        layer.cornerRadius = 10
        layer.masksToBounds = true
        backgroundColor = Constants.Colors.Color_4F525A
        textColor = UIColor.white
        font = UIFont.systemFont(ofSize: 16, weight: .regular)
        updatePlaceholder()
        self.delegate = self
    }

    private func updatePlaceholder() {
        if let placeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        }
    }

    override var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }

    // Настройка отступов
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    //убирать клаву по нажатию кнопки готово
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
