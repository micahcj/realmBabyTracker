//
//  realmBabyTrackerApp.swift
//  realmBabyTracker
//
//  Created by Micah Johsnon on 6/30/23.
//

import SwiftUI

@main
struct realmBabyTrackerApp: App {
    var network = Network()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(network)
        }
    }
}
