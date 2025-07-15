//
//  SignUpViewModelTests.swift
//  ShiftProjectTests
//
//  Created by Valery Zvonarev on 14.07.2025.
//

import XCTest
import Combine
@testable import ShiftProject

final class SignUpViewModelTests: XCTestCase {

    private var viewModel: SignUpViewModel!
    private var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        viewModel = SignUpViewModel()
    }

    override func tearDown() {
        viewModel = nil
        cancellables.removeAll()
        super.tearDown()
    }

    // MARK: - Имя (firstName)
    func testFirstNameValidation_Valid() {
        viewModel.firstName = "Alex"
//        XCTAssertTrue(viewModel.isNameValid)
        XCTAssertFalse(viewModel.isNameBorder)
        XCTAssertEqual(viewModel.errorMessageFirstName, "")
    }

    func testFirstNameValidation_TooShort() {
        viewModel.firstName = "A"
//        XCTAssertFalse(viewModel.isNameValid)
        XCTAssertTrue(viewModel.isNameBorder)
        XCTAssertEqual(viewModel.errorMessageFirstName, "Только буквы, минимум 2 символа, без пробелов")
    }

    func testFirstNameValidation_InvalidCharacters() {
        viewModel.firstName = "Al3x"
//        XCTAssertFalse(viewModel.isNameValid)
        XCTAssertTrue(viewModel.isNameBorder)
    }

    // MARK: - Фамилия (lastName)
    func testLastNameValidation_Valid() {
        viewModel.lastName = "Smith"
//        XCTAssertTrue(viewModel.isLastNameValid)
        XCTAssertFalse(viewModel.isLastNameBorder)
        XCTAssertEqual(viewModel.errorMessageLastName, "")
    }

    func testLastNameValidation_Invalid() {
        viewModel.lastName = "Sm1th"
//        XCTAssertFalse(viewModel.isLastNameValid)
        XCTAssertTrue(viewModel.isLastNameBorder)
    }

    // MARK: - День рождения (dateOfBirth)
    func testDateValidation_Valid() {
        viewModel.dateOfBirth = Calendar.current.date(byAdding: .year, value: -20, to: Date())!
//        XCTAssertTrue(viewModel.isDateValid)
        XCTAssertFalse(viewModel.isDateBorder)
        XCTAssertEqual(viewModel.errorMessageDate, "")
    }

    func testDateValidation_TooOld() {
        viewModel.dateOfBirth = Calendar.current.date(byAdding: .year, value: -101, to: Date())!
//        XCTAssertFalse(viewModel.isDateValid)
        XCTAssertTrue(viewModel.isDateBorder)
    }

    func testDateValidation_FutureDate() {
        viewModel.dateOfBirth = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
//        XCTAssertFalse(viewModel.isDateValid)
        XCTAssertTrue(viewModel.isDateBorder)
    }

    // MARK: - Пароль (passwordFirst)
    func testPasswordValidation_Valid() {
        viewModel.passwordFirst = "StrongPass123"
//        XCTAssertTrue(viewModel.isPasswordValid)
        XCTAssertFalse(viewModel.isPasswordBorder)
        XCTAssertEqual(viewModel.errorMessagePassword, "")
    }

    func testPasswordValidation_TooShort() {
        viewModel.passwordFirst = "Pass1"
//        XCTAssertFalse(viewModel.isPasswordValid)
        XCTAssertTrue(viewModel.isPasswordBorder)
        XCTAssertEqual(viewModel.errorMessagePassword, "Пароль должен содержать минимум 6 символов")
    }

    func testPasswordValidation_CommonPassword() {
        viewModel.passwordFirst = "password"
//        XCTAssertFalse(viewModel.isPasswordValid)
        XCTAssertTrue(viewModel.isPasswordBorder)
        XCTAssertEqual(viewModel.errorMessagePassword, "Этот пароль слишком распространен")
    }

    func testPasswordValidation_NoDigits() {
        viewModel.passwordFirst = "Password"
//        XCTAssertFalse(viewModel.isPasswordValid)
        XCTAssertTrue(viewModel.isPasswordBorder)
        XCTAssertEqual(viewModel.errorMessagePassword, "Этот пароль слишком распространен")
    }

    func testPasswordValidation_NoUppercase() {
        viewModel.passwordFirst = "pass123"
//        XCTAssertFalse(viewModel.isPasswordValid)
        XCTAssertTrue(viewModel.isPasswordBorder)
        XCTAssertEqual(viewModel.errorMessagePassword, "Используйте буквы в обоих регистрах")
    }

    // MARK: - Подтверждение пароля (passwordConfirm)
    func testPasswordMatching_Valid() {
        viewModel.passwordFirst = "StrongPass123"
        viewModel.passwordConfirm = "StrongPass123"
//        XCTAssertTrue(viewModel.isPasswordMatch)
        XCTAssertFalse(viewModel.isPasswordConfirmBorder)
        XCTAssertEqual(viewModel.errorMessageConfirmPassword, "")
    }

    func testPasswordMatching_Invalid() {
        viewModel.passwordFirst = "StrongPass123"
        viewModel.passwordConfirm = "WrongPass123"
//        XCTAssertFalse(viewModel.isPasswordMatch)
        XCTAssertTrue(viewModel.isPasswordConfirmBorder)
        XCTAssertEqual(viewModel.errorMessageConfirmPassword, "Пароли не совпадают")
    }

    // MARK: - Активация кнопки (isButtonEnabled)
    func testSignupButton_InitiallyDisabled() {
        XCTAssertFalse(viewModel.isButtonEnabled)
    }

    func testSignupButton_EnabledWhenAllValid() {
        viewModel.firstName = "Alex"
        viewModel.lastName = "Smith"
        viewModel.dateOfBirth = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.passwordFirst = "StrongPass123"
        viewModel.passwordConfirm = "StrongPass123"
        XCTAssertTrue(viewModel.isButtonEnabled)
    }

    func testSignupButton_DisabledIfOneFieldInvalid() {
        viewModel.firstName = "Alex"
        viewModel.lastName = "Smith"
        viewModel.dateOfBirth = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        viewModel.passwordFirst = "StrongPass123"
        viewModel.passwordConfirm = "WrongPass123" // Не совпадает
        XCTAssertFalse(viewModel.isButtonEnabled)
    }

    // MARK: - Сохранение в UserDefaults
    func testFirstNameSavedToUserDefaults() {
        let testName = "TestUser"
        viewModel.firstName = testName
        XCTAssertEqual(UserDefaults.standard.string(forKey: "firstName"), testName)
    }
}
