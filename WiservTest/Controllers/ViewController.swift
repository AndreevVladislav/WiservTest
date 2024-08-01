//
//  ViewController.swift
//  WiservTest
//
//  Created by Vladislav Andreev on 29.07.2024.
//

import UIKit
import BonsaiController

class ViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.backgroundColor = .none
        return scroll
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let customNavBar: CustomNavigationBar = {
        let nav = CustomNavigationBar()
        nav.translatesAutoresizingMaskIntoConstraints = false
        return nav
    }()
    
    private let contactView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.Color_30323A
        return view
    }()
    
    let nameTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "Магомед"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let phoneTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "+7 (900) 900-00-00"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let wishesView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.Color_30323A
        return view
    }()
    
    let addTextField: CustomTextField = {
        let addTextField = CustomTextField()
        addTextField.attributedPlaceholder = NSAttributedString(string: "Введите, что хотите добавить в заказ", attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.Color_8D8F94 ?? UIColor.gray])
        addTextField.translatesAutoresizingMaskIntoConstraints = false
        return addTextField
    }()


    let deleteTextField: CustomTextField = {
        let deleteTextField = CustomTextField()
        deleteTextField.translatesAutoresizingMaskIntoConstraints = false
        deleteTextField.attributedPlaceholder = NSAttributedString(string: "Введите, что хотите убрать из заказ", attributes: [NSAttributedString.Key.foregroundColor: Constants.Colors.Color_8D8F94 ?? UIColor.gray])
        return deleteTextField
    }()
    
    private let paymentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Constants.Colors.Color_30323A
        return view
    }()
    
    private let changeTextField: CustomTextField = {
        let textField = CustomTextField()
        textField.placeholder = "0"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let buttonPolitics: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.Image.buttonPoliticsNoActive, for: .normal)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let politicsLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 12, weight: .light)
        text.text = "Согласен с условиями Политики обработки персональных данных и Правилами пользования торговой площадкой"
        text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        text.textAlignment = .left
        text.numberOfLines = 0
        return text
    }()
    
    private let buttonOrder: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Constants.Image.buttonOrderNoActive, for: .normal)
        button.setTitle("", for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private let priceLable: UILabel = {
        let text = UILabel()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        text.textAlignment = .center
        text.numberOfLines = 0
        return text
    }()
    
//MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //эмитация получения данных с Api
        getInfo()
        
        view.backgroundColor = Constants.Colors.Color_17191F
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(buttonPolitics)
        contentView.addSubview(politicsLable)
        contentView.addSubview(buttonOrder)
        contentView.addSubview(priceLable)
        priceLable.text = "Заказать - \(Order.price)₽"
        
        createNavBar()
        createContactView()
        createWishesView()
        createInfoView()
        createPaymentView()
        
        
        setConstrains()
        addActions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboard(notification:)), name:UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        
        
    }
    
//поднятие экрана с клавиатурой
    
    @objc func keyboard(notification:Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification {
            let keyboardHeight = keyboardFrame.height
            scrollView.contentInset.bottom = keyboardHeight
            scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
        } else {
            scrollView.contentInset = .zero
            scrollView.verticalScrollIndicatorInsets = .zero
        }
        
    }

//addActions
    
    private func addActions(){
        
        buttonPolitics.addAction(UIAction(handler: { [weak self] _ in
            if Order.politics == false {
                self?.buttonPolitics.setImage(Constants.Image.buttonPoliticsActive, for: .normal)
                self?.buttonOrder.setImage(Constants.Image.buttonOrderActive, for: .normal)
                Order.politics = true
            } else {
                self?.buttonPolitics.setImage(Constants.Image.buttonPoliticsNoActive, for: .normal)
                self?.buttonOrder.setImage(Constants.Image.buttonOrderNoActive, for: .normal)
                Order.politics = false
            }
        }), for: .touchUpInside)
        
        buttonOrder.addAction(UIAction(handler: { [weak self] _ in
            if Order.politics == true {
                Order.contact.name = self?.nameTextField.text ?? ""
                Order.contact.phoneNumber = self?.phoneTextField.text ?? ""
                Order.payment.change = self?.changeTextField.text ?? ""
                Order.wishes.addToOrder = self?.addTextField.text ?? ""
                Order.wishes.removeFromOrder = self?.deleteTextField.text ?? ""
                
                print("_____________________")
                print("Имя: \(Order.contact.name)")
                print("Номер телефона: \(Order.contact.phoneNumber)")
                print("Кому заказ: \(Order.contact.whoseOrder)")
                print("Добавить к заказу: \(Order.wishes.addToOrder)")
                print("Убрать из заказа: \(Order.wishes.removeFromOrder)")
                print("Метод оплаты: \(Order.payment.method)")
                print("Оплата картой?: \(Order.payment.card)")
                print("Оплата наличкой?: \(Order.payment.cash)")
                print("С какой купюры подготовть сдачу: \(Order.payment.change)")
                print("Принята ли политика: \(Order.politics)")
                print("Цена заказа: \(Order.price)")
                print("_____________________")
                
                let alert = UIAlertController(title: "Заказ формлен", message: "Информация о заказе выведена в консоль.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
                
            } else {
                
                let alert = UIAlertController(title: "Warning", message: "Примите политику обработки персональных данных.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(action)
                self?.present(alert, animated: true)
                
            }
            
        }), for: .touchUpInside)
        
    }
    
//setConstrains
    
    private func setConstrains() {
        NSLayoutConstraint.activate([
            
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: customNavBar.bottomAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            buttonPolitics.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonPolitics.bottomAnchor.constraint(equalTo: buttonOrder.topAnchor, constant: -52),
            
            politicsLable.leadingAnchor.constraint(equalTo: buttonPolitics.trailingAnchor, constant: 5),
            politicsLable.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            politicsLable.centerYAnchor.constraint(equalTo: buttonPolitics.centerYAnchor),
            
            
            buttonOrder.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            buttonOrder.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            buttonOrder.centerXAnchor.constraint(equalTo: contactView.centerXAnchor),
            
            priceLable.centerXAnchor.constraint(equalTo: buttonOrder.centerXAnchor),
            priceLable.centerYAnchor.constraint(equalTo: buttonOrder.centerYAnchor),
        ])
    }
}

//MARK: добавление кастомного NavigationBar

extension ViewController {
        
        private func createNavBar() {
            
            customNavBar.setImage(Constants.Image.logoImage ?? UIImage())
            let navigationBar = customNavBar.getNavigationBar()
            let navItem = UINavigationItem(title: "Оформление заказа")
            navItem.leftBarButtonItem = UIBarButtonItem(image: Constants.Image.backButtonImage, style: .plain, target: self, action: nil)
            navigationBar.setItems([navItem], animated: false)
            view.addSubview(customNavBar)
            
            NSLayoutConstraint.activate([
                customNavBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                customNavBar.topAnchor.constraint(equalTo: view.topAnchor),
                customNavBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
}

//MARK: Контактные данные

extension ViewController {
        
        private func createContactView() {
            
            let contactLable: UILabel = {
                let text = UILabel()
                text.translatesAutoresizingMaskIntoConstraints = false
                text.font = UIFont.systemFont(ofSize: 20, weight: .regular)
                text.text = "Контактные данные"
                text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                text.textAlignment = .left
                return text
            }()
            
            let buttonSelf: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setImage(Constants.Image.radioButtonActive, for: .normal)
                button.setTitle(" Заказ себе", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = .clear
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                return button
            }()
            
            let buttonAnother: UIButton = {
                let button = UIButton()
                button.translatesAutoresizingMaskIntoConstraints = false
                button.setImage(Constants.Image.radioButtonNoActive, for: .normal)
                button.setTitle(" Другому", for: .normal)
                button.setTitleColor(UIColor.white, for: .normal)
                button.backgroundColor = .clear
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
                return button
            }()
            
            contentView.addSubview(contactView)
            contactView.addSubview(contactLable)
            contactView.addSubview(nameTextField)
            contactView.addSubview(phoneTextField)
            contactView.addSubview(buttonSelf)
            contactView.addSubview(buttonAnother)
            
            NSLayoutConstraint.activate([
                contactView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                contactView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
                contactView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                
                contactLable.topAnchor.constraint(equalTo: contactView.topAnchor, constant: 16),
                contactLable.leadingAnchor.constraint(equalTo: contactView.leadingAnchor, constant: 16),
                
                nameTextField.topAnchor.constraint(equalTo: contactLable.bottomAnchor, constant: 16),
                nameTextField.leadingAnchor.constraint(equalTo: contactView.leadingAnchor, constant: 16),
                nameTextField.trailingAnchor.constraint(equalTo: contactView.trailingAnchor, constant: -16),
                nameTextField.heightAnchor.constraint(equalToConstant: 50),

                phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 16),
                phoneTextField.leadingAnchor.constraint(equalTo: contactView.leadingAnchor, constant: 16),
                phoneTextField.trailingAnchor.constraint(equalTo: contactView.trailingAnchor, constant: -16),
                phoneTextField.heightAnchor.constraint(equalToConstant: 50),
                
                buttonSelf.leadingAnchor.constraint(equalTo: contactView.leadingAnchor, constant: 16),
                buttonSelf.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 16),
                buttonSelf.bottomAnchor.constraint(equalTo: contactView.bottomAnchor, constant: -16),
                
                buttonAnother.leadingAnchor.constraint(equalTo: buttonSelf.trailingAnchor, constant: 32),
                buttonAnother.centerYAnchor.constraint(equalTo: buttonSelf.centerYAnchor, constant: 0),
            ])
            
            buttonSelf.addAction(UIAction(handler: { [weak self] _ in
                buttonSelf.setImage(Constants.Image.radioButtonActive, for: .normal)
                buttonAnother.setImage(Constants.Image.radioButtonNoActive, for: .normal)
                Order.contact.whoseOrder = "self"
            }), for: .touchUpInside)
            
            buttonAnother.addAction(UIAction(handler: { [weak self] _ in
                buttonSelf.setImage(Constants.Image.radioButtonNoActive, for: .normal)
                buttonAnother.setImage(Constants.Image.radioButtonActive, for: .normal)
                Order.contact.whoseOrder = "another"
            }), for: .touchUpInside)
            
            
        }
}

//MARK: Пожелания к заказу

extension ViewController {
    
    private func createWishesView() {
        
        let wishesLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            text.text = "Пожелания к заказу"
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let addLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            text.text = "Добавить к заказу"
            text.textColor = Constants.Colors.Color_8D8F94
            text.textAlignment = .left
            return text
        }()
        
        
        
        let deleteLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            text.text = "Убрать из заказа"
            text.textColor = Constants.Colors.Color_8D8F94
            text.textAlignment = .left
            return text
        }()

        
        
        contentView.addSubview(wishesView)
        wishesView.addSubview(wishesLable)
        wishesView.addSubview(addLable)
        wishesView.addSubview(addTextField)
        wishesView.addSubview(deleteLable)
        wishesView.addSubview(deleteTextField)
        

        NSLayoutConstraint.activate([
            
            wishesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            wishesView.topAnchor.constraint(equalTo: contactView.bottomAnchor, constant: 8),
            wishesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            wishesLable.topAnchor.constraint(equalTo: wishesView.topAnchor, constant: 16),
            wishesLable.leadingAnchor.constraint(equalTo: wishesView.leadingAnchor, constant: 16),
            
            addLable.leadingAnchor.constraint(equalTo: wishesView.leadingAnchor, constant: 16),
            addLable.topAnchor.constraint(equalTo: wishesLable.bottomAnchor, constant: 12),
            
            addTextField.leadingAnchor.constraint(equalTo: wishesView.leadingAnchor, constant: 16),
            addTextField.topAnchor.constraint(equalTo: addLable.bottomAnchor, constant: 8),
            addTextField.trailingAnchor.constraint(equalTo: wishesView.trailingAnchor, constant: -16),
            addTextField.heightAnchor.constraint(equalToConstant: 50),
            
            deleteLable.leadingAnchor.constraint(equalTo: wishesView.leadingAnchor, constant: 16),
            deleteLable.topAnchor.constraint(equalTo: addTextField.bottomAnchor, constant: 12),
            
            deleteTextField.leadingAnchor.constraint(equalTo: wishesView.leadingAnchor, constant: 16),
            deleteTextField.topAnchor.constraint(equalTo: deleteLable.bottomAnchor, constant: 8),
            deleteTextField.trailingAnchor.constraint(equalTo: wishesView.trailingAnchor, constant: -16),
            deleteTextField.heightAnchor.constraint(equalToConstant: 50),
            deleteTextField.bottomAnchor.constraint(equalTo: wishesView.bottomAnchor, constant: -16),
            
        ])
        
        
    }
}

//MARK: Способ оплаты

extension ViewController {
    
    private func createPaymentView() {
        
        let paymentLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 20, weight: .regular)
            text.text = "Способ оплаты"
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let buttonOnline: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(Constants.Image.radioButtonActive, for: .normal)
            button.setTitle(" Онлайн оплата", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            return button
        }()
        
        let buttonOffline: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(Constants.Image.radioButtonNoActive, for: .normal)
            button.setTitle(" При получении", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            return button
        }()
        
        let buttonAddCard: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(Constants.Image.buttonAddCard, for: .normal)
            button.setTitle("", for: .normal)
            button.backgroundColor = .clear
            return button
        }()
        
        let buttonOfflineCard: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(Constants.Image.buttonOfflineCard, for: .normal)
            button.setTitle("", for: .normal)
            button.backgroundColor = .clear
            return button
        }()
        
        let switchCard: UISwitch = {
            let mySwitch = UISwitch()
            mySwitch.translatesAutoresizingMaskIntoConstraints = false
            mySwitch.isOn = true
            mySwitch.onTintColor = UIColor.white
            mySwitch.thumbTintColor = Constants.Colors.Color_873BFF
            mySwitch.tintColor = Constants.Colors.Color_4F525A
            return mySwitch
        }()
        
        let buttonOfflineNal: UIButton = {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(Constants.Image.buttonOfflineNal, for: .normal)
            button.setTitle("", for: .normal)
            button.backgroundColor = .clear
            return button
        }()
        
        let switchNal: UISwitch = {
            let mySwitch = UISwitch()
            mySwitch.translatesAutoresizingMaskIntoConstraints = false
            mySwitch.isOn = false
            mySwitch.onTintColor = UIColor.white
            mySwitch.thumbTintColor = Constants.Colors.Color_8D8F94
            mySwitch.tintColor = Constants.Colors.Color_4F525A
            return mySwitch
        }()
        
        let changeLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
            text.text = "Нужна сдача"
            text.textColor = Constants.Colors.Color_8D8F94
            text.textAlignment = .left
            return text
        }()
        
        contentView.addSubview(paymentView)
        paymentView.addSubview(paymentLable)
        paymentView.addSubview(buttonOnline)
        paymentView.addSubview(buttonOffline)
        paymentView.addSubview(buttonAddCard)
        
        NSLayoutConstraint.activate([
            
            paymentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paymentView.topAnchor.constraint(equalTo: wishesView.bottomAnchor, constant: 8),
            paymentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paymentView.bottomAnchor.constraint(equalTo: infoView.topAnchor, constant: -33),
//            paymentView.heightAnchor.constraint(equalToConstant: 500),
            
            paymentLable.topAnchor.constraint(equalTo: paymentView.topAnchor, constant: 16),
            paymentLable.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            
            buttonOnline.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            buttonOnline.topAnchor.constraint(equalTo: paymentLable.bottomAnchor, constant: 16),
            
            buttonOffline.leadingAnchor.constraint(equalTo: buttonOnline.trailingAnchor, constant: 32),
            buttonOffline.centerYAnchor.constraint(equalTo: buttonOnline.centerYAnchor),
            
            buttonAddCard.leadingAnchor.constraint(equalTo: paymentView.leadingAnchor, constant: 16),
            buttonAddCard.centerXAnchor.constraint(equalTo: paymentView.centerXAnchor, constant: 0),
            buttonAddCard.topAnchor.constraint(equalTo: buttonOnline.bottomAnchor, constant: 14),
            buttonAddCard.bottomAnchor.constraint(equalTo: paymentView.bottomAnchor, constant: -16),
            
        ])
        
        buttonOnline.addAction(UIAction(handler: { [weak self] _ in
            buttonOnline.setImage(Constants.Image.radioButtonActive, for: .normal)
            buttonOffline.setImage(Constants.Image.radioButtonNoActive, for: .normal)
            
            buttonOfflineCard.removeFromSuperview()
            buttonOfflineNal.removeFromSuperview()
            switchCard.removeFromSuperview()
            switchNal.removeFromSuperview()
            self?.paymentView.addSubview(buttonAddCard)
            
            buttonAddCard.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
            buttonAddCard.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
            buttonAddCard.topAnchor.constraint(equalTo: buttonOnline.bottomAnchor, constant: 14).isActive = true
            buttonAddCard.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
            
            Order.payment.method = "Online"
        }), for: .touchUpInside)
        
        buttonOffline.addAction(UIAction(handler: { [weak self] _ in
            buttonOnline.setImage(Constants.Image.radioButtonNoActive, for: .normal)
            buttonOffline.setImage(Constants.Image.radioButtonActive, for: .normal)
            
            buttonAddCard.removeFromSuperview()
            self?.paymentView.addSubview(buttonOfflineCard)
            self?.paymentView.addSubview(buttonOfflineNal)
            self?.paymentView.addSubview(switchCard)
            self?.paymentView.addSubview(switchNal)

            buttonOfflineCard.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
            buttonOfflineCard.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
            buttonOfflineCard.topAnchor.constraint(equalTo: buttonOnline.bottomAnchor, constant: 14).isActive = true
            
            switchCard.trailingAnchor.constraint(equalTo: buttonOfflineCard.trailingAnchor, constant: -12).isActive = true
            switchCard.centerYAnchor.constraint(equalTo: buttonOfflineCard.centerYAnchor, constant: 0).isActive = true
            
            buttonOfflineNal.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
            buttonOfflineNal.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
            buttonOfflineNal.topAnchor.constraint(equalTo: buttonOfflineCard.bottomAnchor, constant: 16).isActive = true
            buttonOfflineNal.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
            
            switchNal.trailingAnchor.constraint(equalTo: buttonOfflineNal.trailingAnchor, constant: -12).isActive = true
            switchNal.centerYAnchor.constraint(equalTo: buttonOfflineNal.centerYAnchor, constant: 0).isActive = true
            
            Order.payment.method = "Offline"
            Order.payment.card = true
            Order.payment.cash = false
        }), for: .touchUpInside)
        
        buttonAddCard.addAction(UIAction(handler: { [weak self] _ in
            let smallVC = UkassaVC()
//            smallVC.cellsMenuGostevoi = NewsStructNew.temporaryContainerForNews
            smallVC.transitioningDelegate = self
            smallVC.modalPresentationStyle = .custom
            self?.present(smallVC, animated: true, completion: nil)
            //            self?.openNewWindowNews()
        }), for: .touchUpInside)
        
        
        switchCard.addAction(UIAction(handler: { [weak self] _ in
            if switchCard.isOn {
                switchNal.setOn(false, animated: true)
                switchNal.thumbTintColor = Constants.Colors.Color_8D8F94
                switchCard.thumbTintColor = Constants.Colors.Color_873BFF
                self!.changeTextField.removeFromSuperview()
                buttonOfflineNal.removeFromSuperview()
                switchNal.removeFromSuperview()
                changeLable.removeFromSuperview()
                self?.paymentView.addSubview(buttonOfflineNal)
                self?.paymentView.addSubview(switchNal)
                
                buttonOfflineNal.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                buttonOfflineNal.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
                buttonOfflineNal.topAnchor.constraint(equalTo: buttonOfflineCard.bottomAnchor, constant: 16).isActive = true
                buttonOfflineNal.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
                
                switchNal.trailingAnchor.constraint(equalTo: buttonOfflineNal.trailingAnchor, constant: -12).isActive = true
                switchNal.centerYAnchor.constraint(equalTo: buttonOfflineNal.centerYAnchor, constant: 0).isActive = true
                
                Order.payment.method = "Offline"
                Order.payment.card = true
                Order.payment.cash = false
            } else {
                switchNal.setOn(true, animated: true)
                switchNal.thumbTintColor = Constants.Colors.Color_873BFF
                switchCard.thumbTintColor = Constants.Colors.Color_8D8F94
                buttonOfflineNal.removeFromSuperview()
                switchNal.removeFromSuperview()
                self?.paymentView.addSubview(changeLable)
                self?.paymentView.addSubview(buttonOfflineNal)
                self?.paymentView.addSubview(switchNal)
                self?.paymentView.addSubview(self!.changeTextField)
                
                buttonOfflineNal.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                buttonOfflineNal.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
                buttonOfflineNal.topAnchor.constraint(equalTo: buttonOfflineCard.bottomAnchor, constant: 16).isActive = true
                
                switchNal.trailingAnchor.constraint(equalTo: buttonOfflineNal.trailingAnchor, constant: -12).isActive = true
                switchNal.centerYAnchor.constraint(equalTo: buttonOfflineNal.centerYAnchor, constant: 0).isActive = true
                
                changeLable.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                changeLable.topAnchor.constraint(equalTo: buttonOfflineNal.bottomAnchor, constant: 16).isActive = true
                
                self?.changeTextField.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                self?.changeTextField.topAnchor.constraint(equalTo: changeLable.bottomAnchor, constant: 8).isActive = true
                self?.changeTextField.trailingAnchor.constraint(equalTo: self!.paymentView.trailingAnchor, constant: -16).isActive = true
                self?.changeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                self?.changeTextField.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
                
                Order.payment.method = "Offline"
                Order.payment.card = false
                Order.payment.cash = true
            }
        }), for: .valueChanged)
        
        switchNal.addAction(UIAction(handler: { [weak self] _ in
            if switchNal.isOn {
                switchCard.setOn(false, animated: true)
                switchNal.thumbTintColor = Constants.Colors.Color_873BFF
                switchCard.thumbTintColor = Constants.Colors.Color_8D8F94
                
                buttonOfflineNal.removeFromSuperview()
                switchNal.removeFromSuperview()
                self?.paymentView.addSubview(changeLable)
                self?.paymentView.addSubview(buttonOfflineNal)
                self?.paymentView.addSubview(switchNal)
                self?.paymentView.addSubview(self!.changeTextField)
                
                buttonOfflineNal.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                buttonOfflineNal.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
                buttonOfflineNal.topAnchor.constraint(equalTo: buttonOfflineCard.bottomAnchor, constant: 16).isActive = true
                
                switchNal.trailingAnchor.constraint(equalTo: buttonOfflineNal.trailingAnchor, constant: -12).isActive = true
                switchNal.centerYAnchor.constraint(equalTo: buttonOfflineNal.centerYAnchor, constant: 0).isActive = true
                
                changeLable.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                changeLable.topAnchor.constraint(equalTo: buttonOfflineNal.bottomAnchor, constant: 16).isActive = true
                
                self?.changeTextField.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                self?.changeTextField.topAnchor.constraint(equalTo: changeLable.bottomAnchor, constant: 8).isActive = true
                self?.changeTextField.trailingAnchor.constraint(equalTo: self!.paymentView.trailingAnchor, constant: -16).isActive = true
                self?.changeTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
                self?.changeTextField.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
                
                Order.payment.method = "Offline"
                Order.payment.card = false
                Order.payment.cash = true
                
            } else {
                // Ваши действия при выключенном свитче // цвет ползунка при выключенном состоянии
                switchCard.setOn(true, animated: true)
                switchNal.thumbTintColor = Constants.Colors.Color_8D8F94
                switchCard.thumbTintColor = Constants.Colors.Color_873BFF
                
                self!.changeTextField.removeFromSuperview()
                buttonOfflineNal.removeFromSuperview()
                switchNal.removeFromSuperview()
                changeLable.removeFromSuperview()
                self?.paymentView.addSubview(buttonOfflineNal)
                self?.paymentView.addSubview(switchNal)
                
                buttonOfflineNal.leadingAnchor.constraint(equalTo: self!.paymentView.leadingAnchor, constant: 16).isActive = true
                buttonOfflineNal.centerXAnchor.constraint(equalTo: self!.paymentView.centerXAnchor, constant: 0).isActive = true
                buttonOfflineNal.topAnchor.constraint(equalTo: buttonOfflineCard.bottomAnchor, constant: 16).isActive = true
                buttonOfflineNal.bottomAnchor.constraint(equalTo: self!.paymentView.bottomAnchor, constant: -16).isActive = true
                
                switchNal.trailingAnchor.constraint(equalTo: buttonOfflineNal.trailingAnchor, constant: -12).isActive = true
                switchNal.centerYAnchor.constraint(equalTo: buttonOfflineNal.centerYAnchor, constant: 0).isActive = true
                
                Order.payment.method = "Offline"
                Order.payment.card = true
                Order.payment.cash = false
                
            }
        }), for: .valueChanged)
        
        
    }
    
}

//MARK: информация о заказе

extension ViewController {
    
    private func createInfoView() {
        
        let backgroundImage: UIImageView = {
            let image = UIImageView()
            image.image = Constants.Image.gradientBack
            image.contentMode = .scaleAspectFill
            image.translatesAutoresizingMaskIntoConstraints = false
            return image
        }()
        
        let prepaymentTitleLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 12, weight: .light)
            text.text = "Предоплата за бронь столика"
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let prepaymentLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 12, weight: .light)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let countProductLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let priceLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            return text
        }()
        
        let timeLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 12, weight: .light)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            text.text = "Заказ ожидает вас через 23 мин"
            return text
        }()
        
        let itogLable: UILabel = {
            let text = UILabel()
            text.translatesAutoresizingMaskIntoConstraints = false
            text.font = UIFont.systemFont(ofSize: 12, weight: .light)
            text.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            text.textAlignment = .left
            text.text = "Итого на сумму"
            return text
        }()
        
        prepaymentLable.text = "\(Order.prepayment)₽"
        countProductLable.text = "\(Order.countProduct) товара"
        priceLable.text = "\(Order.price) ₽"
        
        contentView.addSubview(infoView)
        infoView.addSubview(backgroundImage)
        infoView.addSubview(prepaymentTitleLable)
        infoView.addSubview(prepaymentLable)
        infoView.addSubview(countProductLable)
        infoView.addSubview(priceLable)
        infoView.addSubview(timeLable)
        infoView.addSubview(itogLable)
        
        NSLayoutConstraint.activate([
            
            infoView.leadingAnchor.constraint(equalTo: contactView.leadingAnchor),
            infoView.trailingAnchor.constraint(equalTo: contactView.trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: politicsLable.topAnchor, constant: -12),
            
            backgroundImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: infoView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: infoView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: infoView.bottomAnchor),
            
            prepaymentTitleLable.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            prepaymentTitleLable.topAnchor.constraint(equalTo: infoView.topAnchor, constant: 20),
            
            prepaymentLable.centerYAnchor.constraint(equalTo: prepaymentTitleLable.centerYAnchor),
            prepaymentLable.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -88),
            
            countProductLable.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            countProductLable.topAnchor.constraint(equalTo: prepaymentTitleLable.bottomAnchor, constant: 2),
            
            priceLable.leadingAnchor.constraint(equalTo: prepaymentLable.leadingAnchor),
            priceLable.centerYAnchor.constraint(equalTo: countProductLable.centerYAnchor),
            
            timeLable.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 10),
            timeLable.topAnchor.constraint(equalTo: countProductLable.bottomAnchor, constant: 12),
            timeLable.bottomAnchor.constraint(equalTo: infoView.bottomAnchor, constant: -20),
            
            itogLable.leadingAnchor.constraint(equalTo: prepaymentLable.leadingAnchor),
            itogLable.centerYAnchor.constraint(equalTo: timeLable.centerYAnchor),
            
            
        ])
        
        
    }
}

//MARK: BonsaiControllerDelegate

extension ViewController: BonsaiControllerDelegate {
    
    func frameOfPresentedView(in containerViewFrame: CGRect) -> CGRect {
        
        return CGRect(origin: CGPoint(x: 0, y: view.frame.height / 2), size: CGSize(width: containerViewFrame.width, height: containerViewFrame.height / (2)))
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        return BonsaiController(fromDirection: .bottom, backgroundColor: UIColor(white: 0, alpha: 0.7), presentedViewController: presented, delegate: self)
        
    }
}

