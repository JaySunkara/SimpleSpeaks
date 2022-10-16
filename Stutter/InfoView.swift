//
//  InfoView.swift
//  Simple Speaks
//
//  Created by Jay Sunkara on 8/23/22.
//

import SwiftUI

struct InfoView: View {
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                
                Form{
                   
                    Section() {
                        HStack{
                            Image(systemName: "house")
                                .foregroundColor(Color.purple)
                                .font(.title2)
                            
                            Spacer()
                            
                            Text("Practice page generates random sentences to practice speaking.")
                                .frame(width: 254, height: 100, alignment: .leading)
                        }
                    }

                    .textCase(nil)
                    
                    Section {
                        HStack{
                            Image(systemName: "pencil")
                                .foregroundColor(Color.purple)
                                .font(.title)
                            
                            Spacer()
                            Text("Click the pencil icon to generate sentences starting with a specific letter that you need help on.")
                                .frame(width: 254, height: 100, alignment: .leading)
                        }
                    }
                    .textCase(nil)
                    
                    Section {
                        HStack{
                            Image(systemName: "hand.draw")
                                .foregroundColor(Color.purple)
                                .font(.title)
                                
                            
                            Spacer()
                            Text("Swipe left to generate another sentence. Your current sentence will be lost unless saved.")
                                .frame(width: 254, height: 100, alignment: .leading)
                        }
                    }
                    .textCase(nil)
                    
                    Section {
                        HStack{
                            Image(systemName: "hand.draw")
                                .foregroundColor(Color.purple)
                                .font(.title)
                            
                            Spacer()
                            Text("Swipe right to save the sentence to practice later and to record your pronunciation. This will be added to the Saved page.")
                                .frame(width: 254, height: 100, alignment: .leading)
                        }
                    }
                    .textCase(nil)
                    
                }
            }
            .navigationTitle("Quick Help")
            
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
