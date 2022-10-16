//
//  DataController.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/6/22.
//

import CoreData
import Foundation


class DataController: ObservableObject{
    let container = NSPersistentContainer(name: "data")
    //load data
    init(){
        container.loadPersistentStores{ description, error in
            
            if let error = error{
                print("Failed to load the data \(error.localizedDescription)")
            }
            
        }
    }
    
    //save the data
    func save(context: NSManagedObjectContext) {
        do{
            try context.save()
            print("Data saved!!! WUHU!!!")
        } catch{
            print("We could not save the data...")
        }
    }
    // add data
    
    func addCard(sentence: String, pronunciation: Double, dateAdded: Date, context: NSManagedObjectContext){
        
        let card = PracticeCard(context: context)
        card.id  = UUID()
        card.sentence = sentence
        card.pronunciation = pronunciation
        card.dateAdded = dateAdded
        
        save(context: context)
    }
    
    func editCard(card: PracticeCard, sentence: String, pronunciation: Double, dateAdded: Date, context: NSManagedObjectContext){
        
        card.sentence = sentence
        card.pronunciation = pronunciation
        card.dateAdded = dateAdded

        
        save(context: context)
    }
}
