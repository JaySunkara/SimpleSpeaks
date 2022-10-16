//
//  SavedCardsPracticeView.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/13/22.
//
import CoreData
import SwiftUI

struct SavedCardsPracticeView: View {
    
    @Environment (\.managedObjectContext) var managedObjContxt
    @Environment(\.dismiss) var dismiss
    @FetchRequest(sortDescriptors: []) var savedCards : FetchedResults<PracticeCard>
    
    
    
    @StateObject var practCards = PracticeCards()
    @State private var letter = ""
    
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                
                Spacer()
                
                ZStack {
                    ForEach(savedCards.shuffled()) { card in
                        CardView(letter: $letter, sentence: card.sentence ?? "", practCards: practCards, isSaved: true)
                    }
                }
                
                
                HStack{
                    
                    Spacer()
                                        
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .navigationTitle("Shuffle")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Label("Saved", systemImage: "chevron.left")
                            .foregroundColor(Color.purple)
                    }
                    .labelStyle(.titleAndIcon)
                    .padding(.trailing,25)
                    .padding(.top,15)
                }
            }
        }
    }
}

struct SavedCardsPracticeView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCardsPracticeView()
    }
}
