//
//  ApiModels.swift
//  WiservTest
//
//  Created by Vladislav Andreev on 01.08.2024.
//

import Foundation

enum Order {
    static var contact: Contact = Contact()
    static var wishes: Wishes = Wishes()
    static var payment: Payment = Payment()
    static var politics: Bool = false
    static var price: Int = 0
    static var countProduct: Int = 0
    static var prepayment: Int = 0
}

struct Contact {
    var name: String = ""
    var phoneNumber: String = ""
    var whoseOrder: String = ""
}

struct Wishes {
    var addToOrder: String = ""
    var removeFromOrder: String = ""
}

struct Payment {
    var method: String = "" //online или offline
    var card: Bool = false
    var cash: Bool = false
    var change: String = ""
}

func getInfo() {
    Order.contact.name = ""
    Order.contact.phoneNumber = ""
    Order.contact.whoseOrder = "self"
    Order.wishes.addToOrder = ""
    Order.wishes.removeFromOrder = ""
    Order.politics = false
    Order.price = 850
    Order.countProduct = 3
    Order.payment.method = "Online"
    Order.payment.card = false
    Order.payment.cash = false
    Order.payment.change = ""
    Order.prepayment = 500
}


