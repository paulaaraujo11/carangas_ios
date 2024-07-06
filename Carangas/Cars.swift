//
//  Cars.swift
//  Carangas
//
//  Created by Denis Janoto on 26/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import Foundation

class Cars:Codable{
    
    
    //CLASSE UTILIZADA PARA ARMAZENAR OS DADOS DO JSON
    
    
    var _id: String?
    var brand: String=""
    var gasType: Int=0
    var name: String=""
    var price: Double=0.0
    
    var gas: String{
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Alcool"
        default:
            return "Gasolina"
        }
        
    }
}


struct Brand:Codable{
    let fipe_name:String
}
