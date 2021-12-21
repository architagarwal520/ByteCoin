
import Foundation


protocol CoinManagerDelegate{
    func didUpdateRate(_ coinManager:CoinManager,coin:CoinModel)
    func didFailWithError(error:Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B7CDA825-2924-4766-9F9B-3CB5BAD54519"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate:CoinManagerDelegate?
    func getCoinPrice(for currency:String){
        let stringUrl = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        print(stringUrl)
        performRequest(urlString:stringUrl)
    }
    
    func performRequest(urlString:String)
    {
        if let url = URL(string: urlString)
        {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                if let urlData = data{
                    if let coin = parseJson(urlData){
                        delegate?.didUpdateRate(self,coin:coin)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJson(_ urlData:Data)->CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: urlData)
            print(decodedData)
            let rate = decodedData.rate
            let currency = decodedData.asset_id_quote
            let coinModel = CoinModel(rate: rate, currency: currency)
            return coinModel
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
