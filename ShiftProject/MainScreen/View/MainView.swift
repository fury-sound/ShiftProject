//
//  MainView.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import SwiftUI

struct MainView: View {
    private let networkService = NetworkService.shared
    //    @State private var storage = UserDefaults()
    @State private var tableData: [NetworkModel] = []
    @AppStorage("firstName") var firstName: String?
    @State private var showingWelcome = false
    @Environment(\.dismiss) private var dismiss

    let imageSize: CGFloat = 100

    var body: some View {
        //        Text("Hello, \(firstName ?? "")!")
//        HStack(alignment: .center) {
            Button(action: {
                showingWelcome = true
            }) {
                Text("Приветствие")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.primary)
//                    .padding(.vertical, 10)
//                    .multilineTextAlignment(.center)
//                    .background(.red)
            }
            .padding(10)
            .buttonStyle(.bordered)
            .sheet(isPresented: $showingWelcome) {
                WelcomeModalView()
            }

//        }

        List(tableData) { item in
            HStack {
                if let imageUrl = item.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(width: imageSize, height: imageSize)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageSize, height: imageSize)
                                    .background(.black)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .clipped()
                            case .failure:
                                Color(.gray)
                                    .frame(width: imageSize, height: imageSize)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            @unknown default:
                                EmptyView()
                        }
                    }
                }
                Text(item.title ?? "No title")
                Spacer()
                Text(item.price != nil ? String(format: "$%.2f", item.price!) : "No price")
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            Task {
                do {
                    tableData = try await networkService.fetchRequest()
                } catch {
                    print("Network error: \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    MainView()
}
