//
//  SignUpModelViewModel.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 08.07.2025.
//

import Foundation
import Combine

final class SignUpViewModel: ObservableObject {
//загрузка основной формы
//    @Published var isLoading: Bool = false
//активация кнопки входа при валидной форме для загрузкм основной формы
    @Published var isButtonEnabled: Bool = false
//контролируемые переменные
    @Published var firstName: String = "" {
        didSet {
            UserDefaults.standard.set(firstName, forKey: "firstName")
        }
    }

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
//        isButtonEnabled = isPasswordValid
    }

    private func validate() {
        //        Publishers.CombineLatest4(
        //            $firstName.map(validName),
        //            $lastName.map(validLastName),
        //            Publishers.CombineLatest($passwordFirst, $passwordConfirm)
        //                .map { self.validPassword($0) && self.matchingPassword($1) },
        //            $dateOfBirth.map { [weak self] date in
        //                self?.validateBirthDate(date) ?? false
        //            }
        //        )
        //        .dropFirst()
        //        .map { $0 && $1 && $2 && $3 }
        //        .assign(to: \.isButtonEnabled, on: self)
        //        .store(in: &cancellables)
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
//        $passwordConfirm
//            .dropFirst()
//            .debounce(for: 0.5, scheduler: RunLoop.main)
//            .map { [self] passwordConfirm in
//                return matchingPassword(passwordFirst, passwordConfirm)
//            }
//            .assign(to: \.isPasswordMatch, on: self)
//            .store(in: &cancellables)


        //        Publishers.CombineLatest($firstName, $lastName)
        //            .map { [self] firstName, lastName in
        //                print("CHECK firstName:", validName(firstName))
        ////                print("CHECK lastName:", validName(lastName))
        ////                print("CHECK:", validName(firstName) && validName(lastName))
        //                return validName(firstName) && validName(lastName)
        //            }
        //            .assign(to: \.isButtonEnabled, on: self)
        //            .store(in: &cancellables)
        //    }
        //        $passwordConfirm
        //            .dropFirst()
        //            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map { [self] passwordConfirm in
        //                return matchingPassword(passwordFirst, passwordConfirm)
        //            }
        //            .assign(to: \.isPasswordMatch, on: self)
        //            .store(in: &cancellables)
        //        Publishers.CombineLatest($passwordFirst, $passwordConfirm)
        //            .dropFirst()
        //            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map { [self] passwordFirst, passwordConfirm in
        //                return matchingPassword(passwordFirst, passwordConfirm)
        //            }
        //            .assign(to: \.isPasswordMatch, on: self)
        //            .store(in: &cancellables)
        //        $firstName
        //            .dropFirst()
        ////            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map(validName)
        //            .assign(to: \.isNameValid, on: self)
        //            .store(in: &cancellables)
        //        $lastName
        //            .dropFirst()
        ////            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map(validLastName)
        //            .assign(to: \.isLastNameValid, on: self)
        //            .store(in: &cancellables)
        //        $passwordFirst
        //            .dropFirst()
        //            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map(validPassword)
        //            .assign(to: \.isPasswordValid, on: self)
        //            .store(in: &cancellables)
        //        $passwordConfirm
        //            .dropFirst()
        //            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map(matchingPassword)
        //            .assign(to: \.isPasswordMatch, on: self)
        //            .store(in: &cancellables)
        //        Publishers.CombineLatest5($firstName, $lastName, $dateOfBirth,  $passwordFirst, $passwordConfirm)
        //        Publishers.CombineLatest4($isNameValid, $isLastNameValid, $isPasswordValid, $isPasswordMatch)
        //            .dropFirst()
        ////            .debounce(for: 0.5, scheduler: RunLoop.main)
        ////            .map { $0 && $1 && $2 && $3 }
        //
        //            .map { [self] isNameValid, isLastNameValid, isPasswordValid, isPasswordMatch in
        //                return validName(firstName) && validLastName(lastName) && validPassword(passwordFirst) && matchingPassword(passwordConfirm)
        //            }
        ////            .map { isNameValid, isLastNameValid, isPasswordValid, isPasswordMatch in
        ////                return isNameValid && isLastNameValid && isPasswordValid && isPasswordMatch
        ////            }
        //            .assign(to: \.isButtonEnabled, on: self)
        //            .store(in: &cancellables)

        //        Publishers.CombineLatest3($firstName, $lastName, $passwordFirst)
        //            .dropFirst()
        //            .debounce(for: 0.5, scheduler: RunLoop.main)
        //            .map { [self] firstName, lastName, passwordFirst in
        ////                print("CHECK:", validName(firstName) && validName(lastName) && validPassword(passwordFirst))
        //                return validName(firstName) && validName(lastName) && validPassword(passwordFirst)
        ////                return validName(firstName) && validName(lastName) && isPasswordValid
        //            }
        //            .assign(to: \.isButtonEnabled, on: self)
        //            .store(in: &cancellables)
        //        Publishers.CombineLatest4(
        //            $firstName.map(validName),
        //            $lastName.map(validLastName),
        //            $passwordFirst.map(validPassword),  // Без debounce!
        //            $passwordConfirm.map(matchingPassword)  // Без debounce!
        //        )
        //        .map { $0 && $1 && $2 && $3 }
        //        .assign(to: \.isButtonEnabled, on: self)
        //        .store(in: &cancellables)
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
        //        print("in validPassword", password)

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

//    func signUp() {
//        isLoading = true
////        errorMessagePassword = ""
//    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: date)
    }
}

// Old methods code
//    private func validateBirthDate(_ date: Date) -> Bool {
//        if date <= Date.now {
//            isDateBorder = false
//            errorMessageDate = ""
//            return true
//        } else {
//            isDateBorder = true
//            errorMessageDate = "Нельзя указать дату в будущем"
//            print(errorMessageDate)
//            return false
//        }
//    }

//    private func validName(_ name: String) -> Bool {
//        //        print("name: \(name)")
//        let isNameValid = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
//        //        print("isNameValid", isNameValid)
//        if isNameValid {
//            isNameBorder = false
//            errorMessageFirstName = ""
//        } else {
//            isNameBorder = true
//            errorMessageFirstName = "Только буквы, минимум 2 символа, без пробелов"
//        }
//        return isNameValid
//        //        return !name.isEmpty
//    }

//    private func validLastName(_ name: String) -> Bool {
//        //        print("name: \(name)")
//        //        let nameRegex = "^[а-яА-Яa-zA-Z]{2,}$"
//        let isNameValid = NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: name)
//        //        print("isNameValid", isNameValid)
//        if isNameValid {
//            isLastNameBorder = false
//            errorMessageLastName = ""
//        } else {
//            isLastNameBorder = true
//            errorMessageLastName = "Только буквы, минимум 2 символа, без пробелов"
//        }
//        return isNameValid
//        //        return !name.isEmpty
//    }

//    private func validPassword(_ password: String) -> Bool {
//        //        print("in validPassword", password)
//
//        let forbiddenPasswords = [
//            "password", "123456", "qwerty", "admin", "welcome",
//            "login", "abc123", "letmein", "master", "hello123"
//        ]
//
//        //        let keyboardSequences = [
//        //            "qwertyuiop", "asdfghjkl", "zxcvbnm",
//        //            "йцукенгшщзхъ", "фывапролджэ", "ячсмитьбю",
//        //            "1234567890"
//        //        ]
//
//        if password.count == 0 {
//            errorMessagePassword = ""
//            //            print("pass is empty")
//            isPasswordBorder = true
//            return false
//        }
//
//        guard password.count >= 6 else {
//            errorMessagePassword = "Пароль должен содержать минимум 6 символов"
//            //            print(errorMessagePassword)
//            isPasswordBorder = true
//            return false
//        }
//
//        // 2. Проверка на запрещенные пароли
//        guard !forbiddenPasswords.contains(password.lowercased()) else {
//            errorMessagePassword = "Этот пароль слишком распространен"
//            //            print(errorMessagePassword)
//            isPasswordBorder = true
//            return false
//        }
//
//        // 3. Проверка регистров
//        let hasUppercase = password.contains(where: { $0.isUppercase })
//        let hasLowercase = password.contains(where: { $0.isLowercase })
//        guard hasUppercase && hasLowercase else {
//            errorMessagePassword = "Используйте буквы в обоих регистрах"
//            //            print(errorMessagePassword)
//            isPasswordBorder = true
//            return false
//        }
//
//        //        let passwordRegex = "^[\\p{L}\\p{N}\\p{P}\\p{S}]{5,}$"
//        //        let isPasswordValid = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
//        //        print("isPasswordValid", isPasswordValid)
//        //        return isPasswordValid
//        errorMessagePassword = ""
//        isPasswordBorder = false
//        return true
//    }
//    private func matchingPassword(_ password: String) -> Bool {
//
//        //        print("in matchingPassword", passwordFirst, password)
//        if password == passwordFirst {
//            isPasswordConfirmBorder = false
//            errorMessageConfirmPassword = ""
//            return true
//        } else {
//            isPasswordConfirmBorder = true
//            errorMessageConfirmPassword = "Пароли не совпадают"
//            print(errorMessageConfirmPassword)
//            return false
//        }
//    }

