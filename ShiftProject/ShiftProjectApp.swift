//
//  ShiftProjectApp.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 08.07.2025.
//

import SwiftUI

@main
struct ShiftProjectApp: App {
    @StateObject var viewModel = SignUpViewModel()

    var body: some Scene {
        WindowGroup {
            if UserDefaults.standard.string(forKey: "firstName") != nil {
                MainView()
            } else {
                SignUpView(viewModel: viewModel)
            }
        }
    }
}
