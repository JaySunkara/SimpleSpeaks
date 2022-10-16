//
//  Settings.swift
//  Stutter
//
//  Created by Jay Sunkara on 8/8/22.
//

import SwiftUI

struct Settings: View {
    
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Form{
                    Section(header: Text("Daily Practice Reminder")){
                    NavigationLink(destination: NotificationView()                    .navigationBarTitle("")
                        .navigationBarHidden(true)) {
                            HStack{
                                Label("Notifications", systemImage: "bell")
                            }
                    }
                    }
                }
                

                
            }
            .navigationTitle("Settings")
        }
    }
    
    
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
