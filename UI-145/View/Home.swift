//
//  Home.swift
//  UI-145
//
//  Created by にゃんにゃん丸 on 2021/03/17.
//

import SwiftUI

struct Home: View {
    @StateObject var model = HomeViewModel()
    var body: some View {
        TabView{
            
           CharactersView()
                .tabItem {
                    
                    
                    
                    Image(systemName: "person.fill")
                    Text("Characters")
                    
                }
            .environmentObject(model)
            
           ComicsView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    
                    Text("Comic")
                    
                }
            .environmentObject(model)
            
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
