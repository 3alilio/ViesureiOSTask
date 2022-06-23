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
            articleImage
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

    private var articleImage: some View {
        WebImageView(url: viewModel.imageUrl, placeholderName: "article-placeholder")
            .aspectRatio(contentMode: .fill)
            .frame(width: 70, height: 70)
            .clipShape(Circle())
            .shadow(radius: 10)
            .overlay(Circle().stroke(UIColor.label.color, lineWidth: 1))
    }
}
