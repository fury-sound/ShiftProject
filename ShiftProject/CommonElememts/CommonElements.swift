//
//  CommonElements.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import SwiftUI

struct CommonTextField: View {
    @ObservedObject var viewModel: SignUpViewModel
    let title: String
    let placeholder: String
    @Binding var text: String
    let id: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black)
            TextField(placeholder, text: $text)
                .padding(12)
                .font(.system(size: 17, weight: .regular))
                .autocorrectionDisabled(true)
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            id == 0 ? (viewModel.isNameBorder ? Color.red : Color.clear) :
                                id == 1 ? (viewModel.isLastNameBorder ? Color.red : Color.clear) :
                                Color.clear,
                            lineWidth: 1
                        )
                )
        }
        .padding(.top, 12)
    }
}

struct WarningText: View {
    @Binding var textToShow: String

    var body: some View {
        Text("\(textToShow)")
            .font(.caption)
            .foregroundStyle(.red)
    }
}

struct PasswordTextField: View {
    @ObservedObject var viewModel: SignUpViewModel
    let title: String
    let placeholder: String
    @State private var isSecure: Bool = true
    @Binding var password: String
    let id: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black)
            ZStack(alignment: .trailing) {
                Group {
                    if isSecure {
                        SecureField(placeholder, text: $password)
                    } else {
                        TextField(placeholder, text: $password)
                    }
                }
                .padding([.vertical, .leading], 12)
                .padding(.trailing, 32)
                .textContentType(.newPassword)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .font(.system(size: 17, weight: .regular))
                .background(.gray.opacity(0.1))
                .cornerRadius(8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            id == 0 ? (viewModel.isPasswordBorder ? Color.red : Color.clear) :
                                id == 1 ? (viewModel.isPasswordConfirmBorder ? Color.red : Color.clear) :
                                Color.clear,
                            lineWidth: 1
                        )
                )
//                    RoundedRectangle(cornerRadius: 8)
//                        .stroke(
//                            id == "110" ? (viewModel.isPasswordBorder ? Color.red : Color.clear) :
//                                id == "111" ? (viewModel.isPasswordConfirmBorder ? Color.red : Color.clear) :
//                                Color.clear,
//                            lineWidth: 1
//                        )
                    //                    if id == "110" {
                    //                            .stroke(viewModel.isPasswordBorder ? Color.red : Color.clear, lineWidth: 1)
                    //                    } else if id == "111" {
                    //                        RoundedRectangle(cornerRadius: 8)
                    //                            .stroke(, lineWidth: 1)
                    //                    }
//                )
                Button(action: {
                    isSecure.toggle()
                }) {
                    Image(systemName: isSecure ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
            }
        }
        .padding(.top, 12)
    }
}

struct DateTextField: View {
    @ObservedObject var viewModel: SignUpViewModel
    let title: String
    let placeholder: String
    @Binding var selectedDate: Date
    @State private var showDatePicker: Bool = false
    @State private var text: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.black)
            HStack {
                TextField(placeholder, text: $text)
                    .padding(12)
                    .font(.system(size: 17, weight: .regular))
                    .background(.gray.opacity(0.1))
                    .cornerRadius(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.isDateBorder ? Color.red : Color.clear, lineWidth: 1)
                    )
                    .disabled(true)
                Button(action: {
                    showDatePicker = true
                }) {
                    Image(systemName: "calendar")
                        .padding(14)
                        .foregroundStyle(.black)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)            }
        }
        .padding(.top, 12)

        .sheet(isPresented: $showDatePicker) {
            VStack {
                DatePicker("Выберите дату",
                           selection: $selectedDate,
                           displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .padding()
                .onChange(of: selectedDate) { newDate in
                    text = viewModel.formatDate(newDate)
                    showDatePicker = false
                }
                Button("Готово") {
                    text = viewModel.formatDate(selectedDate)
                    showDatePicker = false
                }
                .padding()
            }
            //            .presentationDetents([.medium])
            .frame(width: 320, height: 400)
            //            .background(.white)
            .cornerRadius(12)
        }
    }
}

//struct CommonElements: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    CommonElements()
//}
