//
//  ComicsView.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI
import SDWebImageSwiftUI

struct ComicsView: View {
    @EnvironmentObject var model : HomeViewModel
    var body: some View {
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false) {
                
                if model.fetchedComic.isEmpty{
                    
                    ProgressView()
                        .padding(.top,20)
                }
                else{
                    
                    VStack(spacing:10){
                        
                        
                        ForEach(model.fetchedComic){comic in
                            
                            ComicRowView(character: comic)
                            
                        }
                        
                        if model.offset == model.fetchedComic.count{
                            
                            ProgressView()
                                .padding(.vertical)
                                .onAppear(perform: {
                                    
                                    
                                   print("Fetched New Data")
                                    model.FetchComic()
                                })
                        }
                        else{
                            GeometryReader{reader  -> Color in
                                
                                let minY = reader.frame(in:.global).minY
                                
                                let height = UIScreen.main.bounds.height / 1.3
                                
                                if !model.fetchedComic.isEmpty && minY < height{
                                    
                                    DispatchQueue.main.async {
                                        model.offset = model.fetchedComic.count
                                    }
                                    
                                    
                                }
                                
                                
                               return Color.clear
                                
                                
                            }
                            .frame(width: 20, height: 20)
                        }
                        
                    
                    }
                    .padding(.vertical)
                }
                
            }
            .navigationTitle("Marvels Comic")
        }
        .onAppear(perform: {
            
            if model.fetchedComic.isEmpty{
             
                model.FetchComic()
            }
            
        })
    }
}

struct ComicsView_Previews: PreviewProvider {
    static var previews: some View {
        ComicsView()
    }
}

struct ComicRowView : View {
    @EnvironmentObject var model : HomeViewModel
    var character : Comic
    var body: some View{
        
        HStack(alignment:.top,spacing:10){
            
            
            WebImage(url: ExtractImage(data: character.thumbnail))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            
            VStack(alignment: .leading, spacing: 15) {
                
                Text(character.title)
                    .font(.title3)
                    .bold()
                
                if let discription = character.description{
                    
                    Text(discription)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
               
                
                
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
