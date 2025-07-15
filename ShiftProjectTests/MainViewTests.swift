//
//  MainViewTests.swift
//  ShiftProjectTests
//
//  Created by Valery Zvonarev on 15.07.2025.
//

import Testing
import SwiftUI
@testable import ShiftProject

struct MainViewTests {
// MARK: начальное состояние
    @Test func mainViewInitialState() {
        let view = MainView()
        #expect(view.tableData.isEmpty)
        #expect(view.showingWelcome == false)
    }

}
