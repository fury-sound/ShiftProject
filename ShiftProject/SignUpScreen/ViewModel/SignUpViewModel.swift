//
//  SignUpModelViewModel.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 08.07.2025.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {

//активация кнопки входа при валидной форме для загрузки основной формы
    @Published var isButtonEnabled: Bool = false
//контролируемые переменные
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var dateOfBirth: Date = Date()
    @Published var passwordFirst: String = ""
    @Published var passwordConfirm: String = ""
//переменные красной рамки для полей
    @Published var isNameBorder: Bool = false
    @Published var isLastNameBorder: Bool = false
    @Published var isDateBorder: Bool = false
    @Published var isPasswordBorder: Bool = false
    @Published var isPasswordConfirmBorder: Bool = false
//сообщения об ошибках
//    @Published var isFormValid: Bool = false
    @Published var errorMessageFirstName: String = ""
    @Published var errorMessageLastName: String = ""
    @Published var errorMessageDate: String = ""
    @Published var errorMessagePassword: String = ""
    @Published var errorMessageConfirmPassword: String = ""
//переменные внутри ViewModel
    private var isNameValid: Bool = false
    private var isLastNameValid: Bool = false
    private var isDateValid: Bool = false
    private var isPasswordValid: Bool = false
    private var isPasswordMatch: Bool = false
//строка для проверки имени - содержит не менее 2 символов в верхнем или нижнем регистре
    private let nameRegex = "^[а-яА-Яa-zA-Z]{2,}$"
    private var cancellables: Set<AnyCancellable> = []

    init() {
        validate()
    }

    private func isSignupActive() {
        isButtonEnabled = isNameValid && isLastNameValid && isDateValid && isPasswordValid && isPasswordMatch
    }

    private func validate() {
        $firstName
            .dropFirst()
            .sink { [weak self] firstName in
                self?.validName(firstName)
                self?.isSignupActive()
            }
            .store(in: &cancellables)
        $lastName
            .dropFirst()
            .sink { [weak self] lastName in
                self?.validLastName(lastName)
                self?.isSignupActive()
            }
            .store(in: &cancellables)
        $dateOfBirth
            .dropFirst()
            .sink { [weak self] dateOfBirth in
                self?.validateBirthDate(dateOfBirth)
                self?.isSignupActive()
            }
            .store(in: &cancellables)
        $passwordFirst
            .dropFirst()
            .sink { [weak self] passwordFirst in
                self?.validPassword(passwordFirst)
                self?.isSignupActive()
            }
            .store(in: &cancellables)
        $passwordConfirm
            .dropFirst()
            .sink { [weak self] passwordConfirm in
                self?.matchingPassword(passwordConfirm)
                self?.isSignupActive()
            }
            .store(in: &cancellables)
    }


    private func validName(_ name: String) {
        let isValid = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
        errorMessageFirstName = isValid ? "" : "Только буквы, минимум 2 символа, без пробелов"
        isNameBorder = isValid ? false : true
        isNameValid = isValid
    }

    private func validLastName(_ name: String) {
        let isValid = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
        errorMessageLastName = isValid ? "" : "Только буквы, минимум 2 символа, без пробелов"
        isLastNameBorder = isValid ? false : true
        isLastNameValid = isValid
    }

    private func validateBirthDate(_ date: Date) {
        let minDate: Date = Calendar.current.date(byAdding: .year, value: -100, to: Date())!
        isDateValid = date >= minDate && date <= Date.now
        errorMessageDate = isDateValid ? "" : "Некорректная дата рождения"
        isDateBorder = isDateValid ? false : true
    }

    private func matchingPassword(_ password: String) {
        isPasswordMatch = password == passwordFirst && !password.isEmpty
        errorMessageConfirmPassword = isPasswordMatch ? "" : "Пароли не совпадают"
        isPasswordConfirmBorder = isPasswordMatch ? false : true
    }

    private func validPassword(_ password: String) {

        let forbiddenPasswords = [
            "password", "123456", "qwerty", "admin", "welcome",
            "login", "abc123", "letmein", "master", "hello123"
        ]

        let passErrorMessageArray = [
            "Пароль должен содержать минимум 6 символов",
            "Этот пароль слишком распространен",
            "Используйте буквы в обоих регистрах",
            "Пароль должен содержать цифры",
            "Пароль не может быть пустым"
        ]

        // 1a. Проверка на длину пароля - >0
        if password.count == 0 {
            errorMessagePassword = passErrorMessageArray[4]
            isPasswordBorder = true
            return
        }

        // 1b. Проверка на длину пароля - >6
        guard password.count >= 6 else {
            errorMessagePassword = passErrorMessageArray[0] // "Пароль должен содержать минимум 6 символов"
            isPasswordBorder = true
            return
        }

        // 2. Проверка на запрещенные пароли
        guard !forbiddenPasswords.contains(password.lowercased()) else {
            errorMessagePassword = passErrorMessageArray[1] //"Этот пароль слишком распространен"
            isPasswordBorder = true
            return
        }

        // 3. Проверка регистров
        let hasUppercase = password.contains(where: { $0.isUppercase })
        let hasLowercase = password.contains(where: { $0.isLowercase })
        guard hasUppercase && hasLowercase else {
            errorMessagePassword = passErrorMessageArray[2] //"Используйте буквы в обоих регистрах"
            isPasswordBorder = true
            return
        }

        // 4. Проверка на цифры
        guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
            errorMessagePassword = passErrorMessageArray[3]
            isPasswordBorder = true
            return
        }

        errorMessagePassword = ""
        isPasswordBorder = false
        isPasswordValid = true
        matchingPassword(passwordConfirm)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}


