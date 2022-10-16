//
//  NotificationView.swift
//  Simple Speaks
//
//  Created by Jay Sunkara on 8/23/22.
//
import UserNotifications
import SwiftUI

struct NotificationView: View {
    @Environment (\.managedObjectContext) var managedObjContxt
    @Environment(\.dismiss) var dismiss
    
    @State private var notifTime: Date = Date()
    
    @AppStorage("notificationEnabled") private var notificationEnabled = false
    @AppStorage("notificationTime") private var notificationTime = ""
    
    
    
    let center = UNUserNotificationCenter.current()
    
    var body: some View {
        NavigationView{
            VStack{
                
                Form{
                    Section(header: Text("Daily Practice Reminder")) {
                        Toggle(isOn: $notificationEnabled) {
                            HStack{
                                Image(systemName: "bell")
                                    .foregroundColor(.purple)
                                Text("Enable Notifications")
                            }
                        }
                        
                        .onChange(of: notificationEnabled) { newValue in
                            requestPermission()
                            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                            
                            notificationTime = ""
                        }
                        
                        if notificationEnabled{
                            
                            DatePicker("Select Time", selection: $notifTime, displayedComponents: .hourAndMinute)
                                .onAppear{
                                    notifTime = Date()
                                }

                            Text(notificationTime.isEmpty ? "No reminder yet" : notificationTime)
                        }
                    }
                    .textCase(nil)
                }
            }
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button {
                        dismiss()
                    } label: {
                        Label("Settings", systemImage: "chevron.left")
                            .foregroundColor(Color.purple)
                            .labelStyle(.titleAndIcon)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing){
                    Button {
                        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
                        
                        if notificationEnabled {
                            scheduleNotification()
                        }
                        
                        dismiss()
                    } label: {
                        Text("Save")
                            .foregroundColor(notificationEnabled == false ? Color.gray: Color.purple)
                            .bold()
                    }
                    .disabled(!notificationEnabled)
                }
            }
            .navigationTitle("Notifications")
        }
    }
    
    
    func getAllNotifs() {
        
        center.getPendingNotificationRequests { (notifications) in
            print("Count: \(notifications.count)")
            for item in notifications {
                print(item.content)
            }
        }
    }
    
    func requestPermission(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Daily Practice Reminder"
        content.body = "Practice Speaking"
        content.sound = UNNotificationSound.default
        
        // show this notification five seconds from now
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: notifTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        var hour = dateComponents.hour!
        let min = dateComponents.minute!
        var minStr = ""
        var pm = false
        if hour > 12{
            hour -= 12
            pm = true
        }
        
        if min < 10{
            minStr = "0\(min)"
        }
        else{
            minStr = "\(min)"
        }
        
        notificationTime = pm == false ? "Daily reminder at \(dateComponents.hour!):\(minStr) AM" : "Daily reminder at \(hour):\(minStr) PM"
    }
    
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
