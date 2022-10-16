//
//  PracticeView.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/3/22.
//
import Foundation
import SwiftUI

class PracticeCards: ObservableObject{
    @Published var tempCards: [TempPractCard] = []
    
    struct TempPractCard: Identifiable {
        let id = UUID()
        let sentence: String
    }
    
}

struct PracticeView: View {
        
    @State private var showingAddView = false
    @State private var showingInfoView = false
    //CUSTOMIZE
    @State private var showingEditView = false
    @State private var specificLetterSelected: Bool = false
    @State private var letter: String = ""
    
    
    struct TempPractCard: Identifiable {
        let id = UUID()
        let sentence: String
    }

    @StateObject var practCards = PracticeCards()
    

    
    var body: some View {
        
        NavigationView{
            VStack{
                Spacer()
                ZStack {
                    ForEach(practCards.tempCards) { card in
                        CardView(letter: $letter, sentence: card.sentence, practCards: practCards,isSaved: false)
                    }
                }
                
                HStack{
                    
                    Spacer()
                    
                    Text(letter.isEmpty ? "Generating Random Sentences":  "Sentences Starting with: "+letter.uppercased())
                        .multilineTextAlignment(.center)
                        .font(.title2)
                    
                    Spacer()
                }
                Spacer()
                Spacer()
                Spacer()
            }
            .navigationTitle("Practice")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        //toggle information view
                        showingInfoView.toggle()
                        
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(Color.purple)
                            .font(.headline)
                            
                    }
                    .padding()
                    .sheet(isPresented: $showingInfoView) {
                        InfoView()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingEditView.toggle()
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(Color.purple)
                            .font(.title2)
                            
                    }
                    .padding()
                    .sheet(isPresented: $showingEditView) {
                        EditView(specificLetterSelected: $specificLetterSelected, letter: $letter, practCards: practCards)
                    }
                }  
            }
        }
        .onAppear{
            
            getRandomSentence()
            getRandomSentence()
        }
    }
    
    func getRandomSentence(){
        Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/sentence")!)
            let decodedResponse = try? JSONDecoder().decode([RandWord].self, from: data)

            practCards.tempCards.insert(PracticeCards.TempPractCard(sentence: decodedResponse?[0].word ?? ""), at: 0)
        }
    }
}

struct DataMuse: Codable{
    let word: String
    let score: Int
    let tags: [String]?
}

struct RandWord: Codable {
    let word: String
    let definition: String
    let pronunciation: String
}

struct LinguaTools: Codable{
    let result: String
    let sentence: String
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}

