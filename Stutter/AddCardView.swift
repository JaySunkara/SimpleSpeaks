//
//  AddCardView.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/6/22.
//

import SwiftUI

struct AddCardView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @Environment(\.dismiss) var dismiss
    
    var practiceSentence: String
    
    @State private var typed: Bool = false
    
    @State private var sentence: String = ""
    @State private var pronunciation: Double = 0
    
    var body: some View {
        
        VStack{
            HStack{
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(Color.purple)
                }
                .padding(.leading,25)
                .padding(.top,15)
                
                Spacer()
                
                Button{
                    //Add Code to save event
                    DataController().addCard(sentence: sentence, pronunciation: pronunciation, dateAdded: Date(), context: managedObjContxt)
                    
                    dismiss()
                } label: {
                    Text("Add")
                        .bold()
                        .foregroundColor(sentence.isEmpty ? Color.gray: Color.purple)
                        .padding(.trailing,25)
                        .padding(.top,15)
                }
                .disabled(sentence.isEmpty)
            }
                        
            Form{
                ZStack(alignment: .leading) {
                    if sentence.isEmpty {
                        HStack{
                            Text("Enter a sentence...")
                                .font(.custom("Helvetica", size: 20))
                                .foregroundColor(Color.gray)
                                .padding(.top, 24)
                                .padding(.leading, 18.5)
                                .frame(height: 175, alignment: .topLeading)
                            Spacer()
                        }
                    }
                    
                    TextEditor(text: $sentence)
                        .cornerRadius(0.5)
                        .font(.custom("Helvetica", size: 20))
                        .padding(.all)
                        .lineSpacing(5)
                        .frame(height: 175)
                        .onAppear{
                            sentence = practiceSentence
                        }
                }
                 
                Section{
                    VStack{
                        Slider(value: $pronunciation, in: 0...10, step: 0.5)
                            .accentColor(Color.purple)
                            .foregroundColor(Color.purple)
                        Text("Rate your pronouciation: \(pronunciation, specifier: "%.1f")")
                    }
                }
            }
        }
    }
}

struct AddCardView_Previews: PreviewProvider {
    static var previews: some View {
        AddCardView(practiceSentence: "")
    }
}
