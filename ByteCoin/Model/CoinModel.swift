

import Foundation

struct CoinModel{
    let rate:Double
    let currency:String
    
    var rateString:String{
        return String(format: "%.2f", rate)
    }
}

