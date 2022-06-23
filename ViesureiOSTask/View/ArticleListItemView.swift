//
//  TaskItemView.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 26.05.22.

import SwiftUI
import Combine

struct ArticleListItemView<T>: View where T: ArticleListItemViewModelProtocol {

    @ObservedObject var viewModel: T

    var body: some View {
        HStack {
            profileImage
            textVStackBody
        }
    }

    private var textVStackBody: some View {
            VStack(alignment: .leading, spacing: 8) {
                if let title = viewModel.title, !title.isEmpty {
                    Text(title)
                            .font(.title3)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(UIColor.label.color)
                }

                if let description = viewModel.description, !description.isEmpty {
                    Text(description)
                            .font(.body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(UIColor.label.color)
                            .lineLimit(2)
                }

            }
    }

    var profileImage: some View {
        WebImageView(url: viewModel.imageUrl, placeholderName: "placeholder")
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .cornerRadius(35)
    }
}
