//
//  SignUpViewTests.swift
//  ShiftProjectTests
//
//  Created by Valery Zvonarev on 15.07.2025.
//

import Testing
import SwiftUI
@testable import ShiftProject

struct SignUpViewTests {
    // MARK: Тест состояния экрана при открытии
    @Test func initialViewState() {
        let viewModel = SignUpViewModel()
        let view = SignUpView(viewModel: viewModel)
        #expect(view.viewModel.firstName == "")
        #expect(view.viewModel.lastName == "")
        #expect(Calendar.current.isDate(view.viewModel.dateOfBirth, inSameDayAs: Date()))
        #expect(view.viewModel.passwordFirst == "")
        #expect(view.viewModel.passwordConfirm == "")
        #expect(view.viewModel.isButtonEnabled == false)
    }

    // MARK: Тест состояния экрана при внесении валидных данных
    @Test func formValidationFlow() throws {
        let viewModel = SignUpViewModel()
        let view = SignUpView(viewModel: viewModel)
        // Задаем значение даты задано со сдвигом на -25 лет
        guard let mockDate = Calendar.current.date(byAdding: .year, value: -25, to: Date()) else {
            return
        }
        // Симулируем ввод данных
        viewModel.firstName = "Иван"
        viewModel.lastName = "Иванов"
        viewModel.dateOfBirth = mockDate
        viewModel.passwordFirst = "Secure123!"
        viewModel.passwordConfirm = "Secure123!"

        // Проверяем валидацию
        #expect(view.viewModel.isNameBorder == false)
        #expect(view.viewModel.isLastNameBorder == false)
        #expect(view.viewModel.isPasswordBorder == false)
        #expect(view.viewModel.isPasswordConfirmBorder == false)
        #expect(view.viewModel.isDateBorder == false)
        #expect(view.viewModel.isButtonEnabled == true)
    }

}

