//
//  Greet.swift
//  SimpleSpeaks
//
//  Created by Jay Sunkara on 8/22/22.
//

import SwiftUI

struct GreetView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView{
            ZStack{
                VStack(alignment: .leading) {
                    
                    HStack{
                        Text("Simple Speaks is an app dedicated to those who have difficulty talking because of their speech impediment. Through Simple Speaks you can practice speaking and help overcome your struggles.")
                            .bold()
                            .font(.headline)
                            .padding()
                    }
                    
                    Form{
                        Section {
                            HStack{
                                Image(systemName: "person.wave.2.fill")
                                    .foregroundColor(Color.purple)
                                    .font(.title)
                                    
                                Spacer()
                                Text("Practice pronoucing randomly generated sentences and keep track of your progress by scoring yourself.")
                                    .frame(width: 254, height: 100, alignment: .leading)
                            }
                        }
                        .textCase(nil)
                        
                        Section {
                            HStack{
                                Image(systemName: "arrow.triangle.2.circlepath.circle")
                                    .foregroundColor(Color.purple)
                                    .font(.title)
                                
                                Spacer()
                                Text("Save sentences to practice again and add your own custom sentences.")
                                    .frame(width: 254, height: 100, alignment: .leading)
                            }
                        }
                        .textCase(nil)
                        
                        Section {
                            HStack{
                                Image(systemName: "bell")
                                    .foregroundColor(Color.purple)
                                    .font(.title)
                                
                                Spacer()
                                Text("Recieve a daily reminder to practice.")
                                    .frame(width: 254, height: 100, alignment: .leading)
                            }
                        }
                        .textCase(nil)
                        
                    }
                }
                .navigationTitle("Welcome")
                
                VStack{
                    Spacer()
                HStack{
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Text("Lets Start!")
                            .bold()
                            .font(.title3)
                            .frame(width: 200)
                            .foregroundColor(.white)
                            .padding()
                            .background(Capsule(style: .circular).foregroundColor(.purple))
//                                .clipShape(Capsule())
                    }
                    Spacer()
                }
            }
            }

        }

        
    }
}

struct Greet_Previews: PreviewProvider {
    static var previews: some View {
        GreetView()
            .preferredColorScheme(.light)
    }
}
