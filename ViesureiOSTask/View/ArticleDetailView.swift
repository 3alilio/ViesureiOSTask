//
//  ArticleDetailView.swift
//  waterDrop
//
//  Created by Mohamed El-Shawarby on 27.05.22.
//

import SwiftUI

struct ArticleDetailView<T>: View where T: ArticleDetailViewModelProtocol {

    @ObservedObject var viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            UIColor.systemGray5.color.ignoresSafeArea()
            ScrollView {
                VStack {
                    // TODO:- press on picture open in new screen 
                    WebImageView(url: viewModel.detailModel.image, placeholderName: "placeholder")
                        .aspectRatio(contentMode: .fit)
                        .padding(0)
                        .frame(maxHeight: 300)
                        .clipped()

                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.detailModel.title ?? "")
                            .font(.title3)
                            .bold()
                            .multilineTextAlignment(.leading)

                        Text(viewModel.detailModel.date ?? "")
                            .bold()
                            .font(.callout)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)

                        Text(viewModel.detailModel.description ?? "")
                            .font(.body)
                            .multilineTextAlignment(.leading)

                        if let author = viewModel.detailModel.author {
                            Group {
                                Text("Author: ")
                                    .bold()
                                    +
                                Text("\(author)")
                            }
                        }
                    }.padding(8)
                }
            }
        }.navigationBarTitleDisplayMode(.inline)
        .navigationTitle(viewModel.detailModel.title ?? "")
    }
}
