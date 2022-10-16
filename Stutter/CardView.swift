//
//  CardView.swift
//  SwipeTest
//
//  Created by Federico on 06/02/2022.
//

import SwiftUI

struct CardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var offset = CGSize.zero
    @State private var showingAddView = false
    @State private var color: Color = .black
    @Binding var letter: String
    var sentence: String
    @ObservedObject var practCards : PracticeCards
    var isSaved: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 250)
                .border(.purple, width: 6.0)
                .cornerRadius(4)
                .foregroundColor(color)
                .shadow(radius: 4)
            HStack {
                Text(sentence)
                    .padding()
                    .multilineTextAlignment(.center)
                    .frame(width: 325, height: 220, alignment: .center)
                    .font(.title2)
            }
        }
        .onChange(of: colorScheme, perform: { newValue in
            color = (colorScheme == .dark ? .black : .white)
        })
        .onAppear{
            color = (colorScheme == .dark ? .black : .white)
        }
        .offset(x: offset.width * 1, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 90)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    withAnimation {
                        changeColor(width: offset.width)
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        swipeCard(width: offset.width)
                        changeColor(width: offset.width)
                    }
                }
        )
        .sheet(isPresented: $showingAddView) {
            AddCardView(practiceSentence: sentence)
        }
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            
            if isSaved == false{
                if (!letter.isEmpty){
                    Task {
                        //GETTING RANDOM LETTER NOUN
                        let link: String = "https://api.datamuse.com/words?sp=\(letter)*&md=p&max=500"
                        
                        let (data, _) = try await URLSession.shared.data(from: URL(string:link)!)
                        
                        let decodedResponse = try? JSONDecoder().decode([DataMuse].self, from: data)
                        
                        var i = Int.random(in: 0..<(decodedResponse?.count)!)
                        var letterNoun: String = ""
                        while letterNoun.isEmpty{
                            
                            if(decodedResponse?[i].tags?.contains("n") ?? false){
                                letterNoun = decodedResponse?[i].word ?? "Did Not Find Noun"
                            } else{
                                i = Int.random(in: 0..<(decodedResponse?.count ?? 10))
                            }
                        }
                        
                        //GETTING RANDOM VERB
                        let (verbData, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/verb")!)
                        let VerbdecodedResponse = try? JSONDecoder().decode([RandWord].self, from: verbData)
                        let verb = VerbdecodedResponse?[0].word.lowercased() ?? "Verb Error"
                        
                        //GETTING RANDOM OBJECT(NOUN)
                        let (objData, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/verb")!)
                        let ObjdecodedResponse = try? JSONDecoder().decode([RandWord].self, from: objData)
                        let object = ObjdecodedResponse?[0].word.lowercased() ?? "Object Error"
                        
                        // CONTRUCTING THE SENTENCE
                        getLetterSentence(noun: letterNoun, verb: verb, object: object)
                    }
                }
                
                else if (letter.isEmpty) {
                    getRandomSentence()
                }
            }
            
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            if isSaved == false{
                
                showingAddView.toggle()
                
                if (!letter.isEmpty){
                    Task {
                        //GETTING RANDOM LETTER NOUN
                        let link: String = "https://api.datamuse.com/words?sp=\(letter)*&md=p&max=500"
                        
                        let (data, _) = try await URLSession.shared.data(from: URL(string:link)!)
                        
                        let decodedResponse = try? JSONDecoder().decode([DataMuse].self, from: data)
                        
                        var i = Int.random(in: 0..<(decodedResponse?.count)!)
                        var letterNoun: String = ""
                        while letterNoun.isEmpty{
                            
                            if(decodedResponse?[i].tags?.contains("n") ?? false){
                                letterNoun = decodedResponse?[i].word ?? "Did Not Find Noun"
                            } else{
                                i = Int.random(in: 0..<(decodedResponse?.count ?? 10))
                            }
                        }
                        
                        //GETTING RANDOM VERB
                        let (verbData, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/verb")!)
                        let VerbdecodedResponse = try? JSONDecoder().decode([RandWord].self, from: verbData)
                        let verb = VerbdecodedResponse?[0].word.lowercased() ?? "Verb Error"
                        
                        //GETTING RANDOM OBJECT(NOUN)
                        let (objData, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/verb")!)
                        let ObjdecodedResponse = try? JSONDecoder().decode([RandWord].self, from: objData)
                        let object = ObjdecodedResponse?[0].word.lowercased() ?? "Object Error"
                        
                        // CONTRUCTING THE SENTENCE
                        getLetterSentence(noun: letterNoun, verb: verb, object: object)
                    }
                }
                
                else if (letter.isEmpty) {
                    getRandomSentence()
                }
            }
            
            offset = CGSize(width: 500, height: 0)
            
        default:
            offset = .zero
        }
    }
    
    func changeColor(width: CGFloat) {
        
        if isSaved == false{
            switch width {
            case -500...(-130):
                color = .purple
            case 130...500:
                color = .green
            default:
                color = (colorScheme == .dark ? .black : .white)
            }
        }
    }
    
    func getRandomSentence(){
        Task {
            let (data, _) = try await URLSession.shared.data(from: URL(string:"https://random-words-api.vercel.app/word/sentence")!)
            let decodedResponse = try? JSONDecoder().decode([RandWord].self, from: data)
            
            practCards.tempCards.insert(PracticeCards.TempPractCard(sentence: decodedResponse?[0].word ?? ""), at: 0)
        }
    }
    
    func getLetterSentence(noun: String, verb: String, object: String){
        Task{
            let headers = [
                "X-RapidAPI-Key": "ecda7dd904msh364ceb5ff4fb56ap12c267jsn105bf6a47c16",
                "X-RapidAPI-Host": "linguatools-sentence-generating.p.rapidapi.com"
            ]
            
            let request = NSMutableURLRequest(url: NSURL(string: "https://linguatools-sentence-generating.p.rapidapi.com/realise?object=\(object)&subject=\(noun)&verb=\(verb)&subjdet=%E2%80%93")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (LTdata, response, error) -> Void in
                if (error != nil) {
                    print(error)
                } else {
                    let LTdecodedResponse = try? JSONDecoder().decode(LinguaTools.self, from: LTdata!)
//                    practCards.tempCards.removeAll()
                    practCards.tempCards.insert(PracticeCards.TempPractCard(sentence: LTdecodedResponse?.sentence ?? ""), at: 0)

                }
            })
            dataTask.resume()
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(letter: .constant(""), sentence: "Swipe left to get started", practCards: PracticeCards(), isSaved: false)
    }
}

