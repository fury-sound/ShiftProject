//
//  WelcomeModalView.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 13.07.2025.
//

import SwiftUI

struct WelcomeModalView: View {
    @AppStorage("firstName") var firstName: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
            }
            .padding()

            VStack {
                
                Text("Привет, \(firstName ?? "")!")
                    .font(.title)
                    .padding(.bottom, 20)
                Text("Добро пожаловать на курсы Шифт!")
                    .font(.title2)
                    .padding(.bottom, 20)
                Image(.imageLogo2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.blue, lineWidth: 1)
                    )
                Spacer()
            }
            .padding()
            .background(Color.clear)
            .shadow(radius: 10)
            .onTapGesture {
                dismiss()
            }
        }
    }
}

#Preview {
    WelcomeModalView()
}
