//
//  Rest.swift
//  Carangas
//
//  Created by Denis Janoto on 26/03/2019.
//  Copyright © 2019 Denis Janoto. All rights reserved.
//

import Foundation
enum carError{
    case url
    case taskError(error:Error)
    case noResponse
    case noData
    case responseStatusCode(code:Int)
    case invalidJason
    
}

class Rest{
    
    //CLASSE RESPONSÁVEL PELO CONSUMO DA API E SUAS COMUNICAÇÕES (GET-POST-PUT-DELETE)
    
    
    //CRIAÇÃO DA SESSION MANUAL - PODERIA UTILIZAR A PADRÃO (SHARED)
    private static let configuration:URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.httpAdditionalHeaders = ["Content-Type":"application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
        
    }()
    
    //Caminho da API
    private static let basePath = "https://carangas.herokuapp.com/cars"
    
    //Cria uma sessão entre o APP e a API
    private static let session = URLSession(configuration:configuration)
    
    //Método class é igual metodo static
    //O uso de @scaping na closure faz com que determinado parametro fique "retido" ou em aguardo, mesmo após a finalização do método
    
    
    //GET - LOADMARCAS
    class func loadMarcas(onComplete:@escaping ([Brand]?)->Void){
        guard let url = URL(string: "https://fipeapi.appspot.com/api/1/carros/marcas.json")else{
            //Retorno para a closure o erro url contido no enum(carError)
            onComplete(nil)
            return}
        
        //Recebe os dados do servidor
        //OBS: a dataTask é executada em outra thread, liberando o usuário para uso simultaneo no app
        let dataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else{
                      onComplete(nil)
                    return}
                //se resposta for ok
                if response.statusCode == 200{
                    //Armazenar os dados do servidor na variavel data
                    guard let data = data else{return}
                    
                    //Tranformar json em array
                    do{
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        //Coloca os dados na closure contido no parametro do metodo loadCar() para retornar os dados para qualquer classe que chamar o método loadCar()
                        onComplete(brands)
                        
                        
                    }catch{
                        print(error.localizedDescription)
                          onComplete(nil)
                    }
                }else{
                    print("Algum status inválido no servidor!!")
                      onComplete(nil)
                }
            }else{
                  onComplete(nil)
            }
        }
        dataTask.resume()
    }
    
    

    //GET - LOADCARS
    class func loadCars(onComplete:@escaping ([Cars])->Void,onError:@escaping (carError)->Void){
        //Cria a url https://carangas.herokuapp.com/cars
        guard let url = URL(string: basePath)else{
            //Retorno para a closure o erro url contido no enum(carError)
            onError(.url)
            return}
        
        //Recebe os dados do servidor
        //OBS: a dataTask é executada em outra thread, liberando o usuário para uso simultaneo no app
        let dataTask = session.dataTask(with: url) { (data:Data?, response:URLResponse?, error) in
            if error == nil{
                guard let response = response as? HTTPURLResponse else{
                    onError(.noResponse)
                    return}
                //se resposta for ok
                if response.statusCode == 200{
                    //Armazenar os dados do servidor na variavel data
                    guard let data = data else{return}
                    
                    //Tranformar json em array
                    do{
                        let cars = try JSONDecoder().decode([Cars].self, from: data)
                        //Coloca os dados na closure contido no parametro do metodo loadCar() para retornar os dados para qualquer clase que chamar o método loadCar()
                        onComplete(cars)
                        
                        
                    }catch{
                        print(error.localizedDescription)
                        onError(.invalidJason)
                    }
                }else{
                    print("Algum status inválido no servidor!!")
                    onError(.responseStatusCode(code: response.statusCode))
                }
            }else{
                onError(.taskError(error: error!))
            }
        }
        dataTask.resume()
    }
    
    //POST
    class func saveCar(car:Cars, onComplete:@escaping (Bool)->Void){
        guard let url = URL(string: basePath)else{
            
            onComplete(false)
            return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let json = try? JSONEncoder().encode(car)else{
            onComplete(false)
            return
            
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                
                guard let response = response as? HTTPURLResponse,response.statusCode == 200,let _ = data else{
                    onComplete(false)
                    return
                }
                onComplete(true)
            }else{
                onComplete(false)
            }
        }
        dataTask.resume()
    }
    
    //PUT (UPDATE)
    class func updateCar(car:Cars, onComplete:@escaping (Bool)->Void){
        let urlString = basePath + "/" + car._id!
        guard let url = URL(string: urlString)else{
            
            onComplete(false)
            return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        guard let json = try? JSONEncoder().encode(car)else{
            onComplete(false)
            return
            
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                
                guard let response = response as? HTTPURLResponse,response.statusCode == 200,let _ = data else{
                    onComplete(false)
                    return
                }
                onComplete(true)
            }else{
                onComplete(false)
            }
        }
        dataTask.resume()
    }
    
    //DELETE
    class func deleteCar(car:Cars, onComplete:@escaping (Bool)->Void){
        let urlString = basePath + "/" + car._id!
        guard let url = URL(string: urlString)else{
            
            onComplete(false)
            return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        guard let json = try? JSONEncoder().encode(car)else{
            onComplete(false)
            return
            
        }
        request.httpBody = json
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil{
                
                guard let response = response as? HTTPURLResponse,response.statusCode == 200,let _ = data else{
                    onComplete(false)
                    return
                }
                onComplete(true)
            }else{
                onComplete(false)
            }
        }
        dataTask.resume()
    }
}


