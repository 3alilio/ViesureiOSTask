//
//  ArticlesView.swift
//  
//
//  Created by Mohamed El-Shawarby on 24.05.22.
//

import SwiftUI
import Combine

struct ArticlesView<T>: View where T: ArticlesViewModelProtocol {

    @ObservedObject var viewModel: T

    init(viewModel: T) {
       self.viewModel = viewModel
       self.viewModel.sendGetArticlesRequest()

       let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.tintColor = UIColor.label
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        let tableViewAppearence = UITableView.appearance()
        tableViewAppearence.separatorColor = .clear
    }

    var body: some View {
        NavigationView {
            ZStack {
                UIColor.systemGray5.color.ignoresSafeArea()
//                if let vm = viewModel.selectedItem {
//                    NavigationLink(destination: ArticleDetailView(viewModel: vm), isActive: $viewModel.showDetail) { EmptyView() }
//                }
                VStack {
                    switch viewModel.viewState {
                    case .articles(let articles):
                        List(articles, id: \.id) { article in
                            Button(action: {
//                                viewModel.userSelectItem(item: article)
                            }, label: {
                                ArticleListItemView(viewModel: article)
                            })
                            .listRowBackground(Color(UIColor.systemGray5)).padding()
                            .background(Color(UIColor.systemGray2))
                            .cornerRadius(5)
                        }
                        .listStyle(PlainListStyle())

                    case .loading:
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle.circular)
                            .scaleEffect(2)
                        Spacer()
                    case .emptyDataSet(let model):
                        EmptyDataSetView(viewData: model).frame(maxHeight: .infinity)
                    }
                }
                .navigationBarTitle(Text(viewModel.title))
            }.navigationBarTitleDisplayMode(.inline)
        }
    }
 }
