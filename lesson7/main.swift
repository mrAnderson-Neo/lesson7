//
//  main.swift
//  lesson7
//
//  Created by Андрей Калюжный on 25.03.2021.
//

import Foundation

//
enum TypeError: Error {
    case invalidSelection
    case outOfStocks (count: Int)
    case insufficientFunds(coinsNeeded: Int)
    
    var localizedDiscriotion: String {
        switch self {
        case .invalidSelection:
            return "Нет в ассортименте"
        case .outOfStocks(count: let count):
            return "Не хватает в количестве \(count)"
        case .insufficientFunds(coinsNeeded: let coinsNeeded):
            return "Недостаточно денег \(coinsNeeded)"
        }
    }
    
}

struct Product {
    let name: String
    var price: Float
    var count = 0
}


extension Product {
    mutating func increasTheQuantity(_ count: Int) {
        if count > 0 {
            self.count += count
        }
    }
    
    mutating func reduseTheQuantity(_ count: Int) {
        if count < 0 {
            self.count -= count
        }
    }
    
}

class Shop {
    var listOfGoods: Array<Product> = []
    var mapOfProducts: Dictionary<String, Product> = [:]
    
    init(listOfGoods: Array<Product>) {
        self.listOfGoods = listOfGoods
    }
    
    // здесь проверка на передачу отрицательного числа
    func averagePrice() -> Float {
        guard !listOfGoods.isEmpty else { return 0 }
        
        var result: Float = 0
        
        for elem in listOfGoods {
            result += elem.price
        }
        
        return result/Float(listOfGoods.count)
    }
    
}

//
extension Shop {
    
    func fillInTheProductMap() {
        for element in listOfGoods {
            mapOfProducts.updateValue(element, forKey: element.name)
        }
    }
    
    func sale(_ nameProduct: String, countForSale: Int) throws -> Product {
        guard let prod = mapOfProducts[nameProduct] else {
            throw TypeError.invalidSelection
        }
        
        guard prod.count > countForSale else {
            throw TypeError.outOfStocks(count: countForSale - prod.count)
        }
        
        var newProd = prod
        newProd.reduseTheQuantity(countForSale)
        mapOfProducts[nameProduct] = newProd
        
        return newProd
    }
    
}
//

func trySell(_ nameProduct: String, count: Int) {
    do {
        let sell = try shop.sale(nameProduct, countForSale: count)
        print("Продан товар \(sell.name)")
    }catch let error {
        print(error.localizedDescription)
    }
}


var arrProduct = [Product]()
arrProduct.append(Product(name: "Spoon", price: 10.4, count: 2))
arrProduct.append(Product(name: "Table", price: 100.55, count: 2))
arrProduct.append(Product(name: "Armchair", price: 107.9, count: 3))


var shop = Shop(listOfGoods: arrProduct)
shop.fillInTheProductMap()

//for (key, value) in shop.mapOfProducts {
//    print("key \(key) value \(value)")
//}

trySell("Билибирда", count: 10)
trySell("Spoon", count: 7)
trySell("Armchair", count: 2)

//

