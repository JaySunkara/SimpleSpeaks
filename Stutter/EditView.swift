//
//  EditView.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/8/22.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var tggleTest = false
    @Binding var specificLetterSelected: Bool
    @Binding  var letter: String
    @State private var changed: Bool = false
    @State private var changedToggle: Bool = false
    
    @State private var isLetter: Bool = false
    
    @ObservedObject var practCards : PracticeCards

    
    var body: some View {
        
        NavigationView {
            
            VStack() {
                
                Form{
                    Section(header: Text("Practice with sentences starting with a specific letter")){
                        Toggle("Specific Letter", isOn: $specificLetterSelected.animation())
                            .onAppear{
                                changedToggle = false
                            }
                            .onChange(of: specificLetterSelected) { newValue in
                                changedToggle = true

                            }
                        
                        if specificLetterSelected {
                            TextField("Type one letter", text: $letter)
                                .keyboardType(.default)
                                .autocapitalization(.none)
                                .onAppear{
                                    changed = false
                                }
                                .onChange(of: letter) { newValue in
                                    changed = true
                                    
                                    isLetter = containsOnlyLetters(input: letter)
                                }
     
                            if(letter.count>1){
                                Text("Please enter one letter").foregroundColor(Color.red)
                            }
                            if isLetter == false && !letter.isEmpty{
                                Text("Only alphabet letters are accepted").foregroundColor(Color.red)
                            }
                        }
                    }
                    .textCase(nil)
                }          
            }
            .navigationTitle("Customize")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        if changed{
                            letter = ""
                        }
                        
                        if changedToggle{
                            specificLetterSelected = false
                        }
                        
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(Color.purple)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if specificLetterSelected == false{
                            letter = ""
                        }
                        
                        practCards.tempCards = Array(practCards.tempCards.dropFirst(practCards.tempCards.count-1))
                        
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
                                
                                //ADD ANOTHER SENTENCE TO PREVENT SOME LAG
                                
                            }
                            
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
                                
                                //ADD ANOTHER SENTENCE TO PREVENT SOME LAG
                                
                            }
                        }
                        
                        else if (letter.isEmpty) {
                            getRandomSentence()
                        }
                        
                        dismiss()
                        
                    } label: {
                        Text("Update")
                            .bold()
                            .foregroundColor(letter.count > 1 || letter.count == 0 || !isLetter ? Color.gray: Color.purple)
                    }
                    .disabled(letter.count > 1 || letter.count == 0 || !isLetter)
                }
            }
        }
        .interactiveDismissDisabled()
    }
    
    func containsOnlyLetters(input: String) -> Bool {
       for chr in input {
          if (!(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") ) {
             return false
          }
       }
       return true
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


struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(specificLetterSelected: .constant(false), letter: .constant(""), practCards: PracticeCards())
    }
}
