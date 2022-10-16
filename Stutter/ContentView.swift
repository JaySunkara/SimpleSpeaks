//
//  ContentView.swift
//  Stutter
//
//  Created by Jay Sunkara on 7/31/22.
//

import SwiftUI

struct ContentView: View {
    @State private var selection = 2
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    @State private var showingGreetView = false

    var body: some View {

        TabView(selection: $selection) {
            SavedCardsView()
            .tabItem {
                Label("Saved", systemImage: "arrow.triangle.2.circlepath.circle")
            }
            .tag(1)

            PracticeView()
            .tabItem {
                Label("Practice", systemImage: "house")
            }
            .tag(2)

            Settings()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
            .tag(3)

        }
        .onAppear{
            firstLaunch()
   
        }
        .sheet(isPresented: $showingGreetView) {
            GreetView()
        }
        .accentColor(Color.purple)
    }
    
    func firstLaunch() {
        if launchedBefore  {
            print("Not first launch.")
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            showingGreetView.toggle()
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
