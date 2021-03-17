//
//  HomeViewModel.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI
import Combine
import CryptoKit


class HomeViewModel: ObservableObject {
    @Published var searchQuery = ""
    
    @Published var fetchedCharacters : [Character]? = nil
    
    @Published var fetchedComic : [Comic] = []
    
    var seachCancellable : AnyCancellable? = nil
    @Published var offset : Int = 0
    
    init() {
        seachCancellable = $searchQuery
            .removeDuplicates()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink(receiveValue: { (str) in
                if str == ""{
                    
                    self.fetchedCharacters = nil
                    
                }
                
                else{
                    self.fetchedCharacters = nil
                    self.SearchCharacters()
                }
            })
        
    }
    
    func SearchCharacters(){
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let originalQuery = searchQuery.replacingOccurrences(of: " ", with: "%20")
        let url = "https://gateway.marvel.com:443/v1/public/characters?nameStartsWith=\(originalQuery)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        

        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if let error = err{
                
                print(error.localizedDescription)
                return
            }
            guard let APIDATA = data else {
                
                print("Not data Found")
                return
            }
            
            do{
                
                let characters = try JSONDecoder().decode(ApiResults.self, from: APIDATA)
                
                DispatchQueue.main.async {
                    if self.fetchedCharacters == nil{
                        
                        self.fetchedCharacters = characters.data.results
                        
                    }
                }
                
                
            }
            
            catch{
                
                print(error.localizedDescription)
            }
            
        }
        .resume()
        
    }
    
    func MD5(data:String)->String{
        
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        
        return hash.map{
            
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    func FetchComic(){
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let url = "https://gateway.marvel.com:443/v1/public/comics?limit=20&offset=\(offset)&ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        

        let session = URLSession(configuration: .default)
        
        session.dataTask(with: URL(string: url)!) { (data, _, err) in
            if let error = err{
                
                print(error.localizedDescription)
                return
            }
            guard let APIDATA = data else {
                
                print("Not data Found")
                return
            }
            
            do{
                
                let characters = try JSONDecoder().decode(APIComicResults.self, from: APIDATA)
                
                DispatchQueue.main.async {
                
                        
                    self.fetchedComic.append(contentsOf: characters.data.results)
                        
                  
                }
                
                
            }
            
            catch{
                
                print(error.localizedDescription)
            }
            
        }
        .resume()
        
    }
    
}

