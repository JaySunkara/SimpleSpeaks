//
//  SavedPracticeCardsView.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/6/22.
//

import SwiftUI
import CoreData

struct SavedCardsView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.dateAdded, order: .reverse)]) var savedCards: FetchedResults<PracticeCard>
    
    @State private var showingAddView = false
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack(alignment: .leading) {
                    if savedCards.isEmpty{
                        Text("No Saved Cards\n\nClick the icon to add a custom sentence or save a card from the practice menu")
                            .foregroundColor(.gray)
                            .padding([.horizontal])
                            .frame(alignment: .center)
                    }
                    else
                    {
                        Text("")
                            .padding(.horizontal)
                    }
                    
                    List {
                        ForEach(savedCards) { card in
                            NavigationLink(destination: UpdateCardView(card: card)
                                .navigationBarTitle("")
                                .navigationBarHidden(true)) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 6) {
                                            Text(card.sentence!.count >= 110 ? String(card.sentence!.prefix(110) + "...") : card.sentence!)
                                                .bold()
                                            Text("Pronouciation: \(card.pronunciation, specifier: "%.1f")/10.0")
                                        }
                                        Spacer()
                                    }
                                    .frame(height: 75)
                                }
                        }
                        .onDelete(perform: deleteCard)
                    }
                    .listStyle(.insetGrouped)
                    
                }
                .navigationTitle("Saved Sentences")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddView.toggle()
                        } label: {
                            Label("Add card", systemImage: "plus.circle")
                                .foregroundColor(Color.purple)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        EditButton()
                            .foregroundColor(Color.purple)
                    }
                }
                .sheet(isPresented: $showingAddView) {
                    AddCardView(practiceSentence: "")
                }
                VStack{
                    Spacer()
                    NavigationLink(destination: SavedCardsPracticeView()                            .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            HStack(alignment: .top){
                                Spacer()
                                
                                Image(systemName: "shuffle.circle.fill")
                                    .font(.system(size: 50))
                                    .padding()
                                    .foregroundColor(Color.purple)
                            }
                        }
                }
            }
        }
    }
    
    private func deleteCard(offsets: IndexSet) {
        withAnimation {
            offsets.map { savedCards[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

struct SavedCardsView_Previews: PreviewProvider {
    static var previews: some View {
        SavedCardsView()
    }
}
