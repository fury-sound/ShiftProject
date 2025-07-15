//
//  MainView.swift
//  ShiftProject
//
//  Created by Valery Zvonarev on 09.07.2025.
//

import SwiftUI

struct MainView: View {
    private let networkService: NetworkServiceProtocol
    @State internal var tableData: [NetworkModel] = []
    @State internal var showingWelcome = false
    @Environment(\.dismiss) private var dismiss
    let imageSize: CGFloat = 100

    init(networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.networkService = networkService
    }

    var body: some View {
        Button(action: {
            if UserDefaults.standard.string(forKey: "firstName") != nil {
                showingWelcome = true
            }
        }) {
            Text("Приветствие")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.primary)
        }
        .padding(10)
        .buttonStyle(.bordered)
        .sheet(isPresented: $showingWelcome) {
            WelcomeModalView()
        }
        // Для простоты использован List
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
//            removeNameKey()
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
