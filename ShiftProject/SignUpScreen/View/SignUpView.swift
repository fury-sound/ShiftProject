//
//  SignUpView.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel: SignUpViewModel
    @State private var isShowingMainView = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("ШИФТ")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("курсы")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .center)
                    CommonTextField(viewModel: viewModel, title: "Имя", placeholder: "Имя", text: $viewModel.firstName, id: 0)
                    WarningText(textToShow: $viewModel.errorMessageFirstName)
                    CommonTextField(viewModel: viewModel, title: "Фамилия", placeholder: "Фамилия", text: $viewModel.lastName, id: 1)
                    WarningText(textToShow: $viewModel.errorMessageLastName)
                    DateTextField(viewModel: viewModel, title: "Дата рождения", placeholder: "\(viewModel.formatDate(Date.now))", selectedDate: $viewModel.dateOfBirth)
                    WarningText(textToShow: $viewModel.errorMessageDate)
                    PasswordTextField(viewModel: viewModel, title: "Пароль", placeholder: "Пароль", password: $viewModel.passwordFirst, id: 0)
                    WarningText(textToShow: $viewModel.errorMessagePassword)
                    PasswordTextField(viewModel: viewModel, title: "Подтвердите пароль", placeholder: "Подтвердите пароль", password: $viewModel.passwordConfirm, id: 1)
                    WarningText(textToShow: $viewModel.errorMessageConfirmPassword)

                    HStack {
                        Button(action: {
                            UserDefaults.standard.set(viewModel.firstName, forKey: "firstName")
                            isShowingMainView = true
                        }) {
                            HStack(spacing: 8) {
                                Text("Регистрация")
                                    .font(.system(size: 20, weight: .medium))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 20, weight: .medium))
                            }
                            .foregroundColor(viewModel.isButtonEnabled ? .blue : .gray)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isButtonEnabled ? .green : .gray.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.blue, lineWidth: 2)
                            )
                        }
                        .disabled(!viewModel.isButtonEnabled)
                        .background(
                            NavigationLink(
                                destination: MainView().navigationBarBackButtonHidden(true),
                                isActive: $isShowingMainView,
                                label: { EmptyView() }
                            )
                            .hidden()
                        )
                    }
                    .padding(.vertical, 25)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
            }
            .padding(.top)
        }
        .onAppear() {
            UserDefaults.standard.removeObject(forKey: "firstName")
        }
    }
}

#Preview {
    let viewModel = SignUpViewModel()
    SignUpView(viewModel: viewModel)
}
