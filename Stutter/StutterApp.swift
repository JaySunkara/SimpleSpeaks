//
//  StutterApp.swift
//  Stutter
//
//  Created by Jay Sunkara on 7/31/22.
//
import CoreData
import SwiftUI

@main
struct StutterApp: App {
    @StateObject private var dataController = DataController()
    @StateObject var tempPracticeCards = PracticeCards()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .colorScheme(.dark)
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(tempPracticeCards)
        }
    }
}
