import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailwithError(error: Error)
}


struct WeatherManager {
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=da2b78c84040c4db20f7eeea94f9c75c&units=metric&"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String) {
        let urlString = "\(url)q=\(cityName)"
        
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailwithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                    
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
         let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
            let name = decodedData.name
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            
            print(name,id,temp)
            
            let weather = WeatherModel(cityName: name, conditionId: id, temperature: temp)
            return weather
           
        } catch {
            delegate?.didFailwithError(error: error)
            return nil
            fghjkjhgfdgh
        }
    }
    
    

}
