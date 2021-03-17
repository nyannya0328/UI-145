//
//  CharactersView.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct CharactersView: View {
    @EnvironmentObject var model : HomeViewModel
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false, content: {
                
                VStack(spacing:15){
                    
                    HStack(spacing:15){
                        
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Search Characters", text: $model.searchQuery)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                        
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: 5, y: 5)
                    .shadow(color: Color.black.opacity(0.03), radius: 5, x: -5, y: -5)
                }
                .padding()
                
                if let characters = model.fetchedCharacters{
                    
                    if characters.isEmpty{
                       Text("No Results")
                        .padding(.top,20)
                            
                            
                    }
                    else{
                        
                        ForEach(characters){data in
                            
                           CharacterRowView(character: data)
                            
                            
                        }
                    }
                }
                else{
                    
                    if model.searchQuery != ""{
                        
                        ProgressView()
                            .padding(.top,20)
                    }
                }
            
                
            })
            .navigationTitle("Marvel")
        }
       
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}

struct CharacterRowView : View {
    @EnvironmentObject var model : HomeViewModel
    var character : Character
    var body: some View{
        
        HStack(alignment:.top,spacing:10){
            
            
            WebImage(url: ExtractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text(character.name)
                    .font(.title3)
                    .bold()
                
                Text(character.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                
                
                HStack(spacing:10){
                    
                    ForEach(character.urls,id:\.self){data in
                        
                        
                        NavigationLink(destination: WebView(url: ExtractURL(data: data)).navigationTitle(ExtractURLType(data: data)), label: {
                            
                            Text(ExtractURLType(data: data))
                            
                        })
                    }
                    
                }
                
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal)
        
    }
    func ExtractImage(data:[String : String]) -> URL{
        
        let path = data["path"] ?? ""
        let ext = data["extension"] ?? ""
        
        return URL(string: "\(path).\(ext)")!
        
    }
    
    func ExtractURL(data:[String:String])->URL{
        
        let url = data["url"] ?? ""
        return URL(string: url)!
        
        
    }
    
    func ExtractURLType(data:[String : String])-> String{
        
        
        let type = data["type"] ?? ""
        return type.capitalized
    }
}
