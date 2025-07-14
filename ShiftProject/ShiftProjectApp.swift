//
//  ShiftProjectApp.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 08.07.2025.
//

import SwiftUI

@main
struct ShiftProjectApp: App {
    
    var body: some Scene {
        WindowGroup {
//            ContentView()
            if UserDefaults.standard.string(forKey: "firstName") != nil {
                MainView()
            } else {
                SignUpView()
            }
        }
    }
}
