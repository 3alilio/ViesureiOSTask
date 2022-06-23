//
//  Model.swift
//  
//
//  Created by Mohamed El-Shawarby on 24.05.22.

 import SwiftUI

struct EmptyDataSetData {
    var tryAgainHandler : (() -> Void)?
    var title: String?
    var descriptionText: String?
    var buttonTitle: String?
}

 struct EmptyDataSetView: View {

    private let textColor = Color(UIColor.secondaryLabel)
    var viewData: EmptyDataSetData

    var body: some View {
        ZStack {
            VStack(alignment: .center) {

                if let title = viewData.title {
                    Text(title)
                    .font(.title)
                    .foregroundColor(textColor)
                    .padding()
                }

                if let description = viewData.descriptionText {
                    Text(description)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .padding()
                }

                if let buttonTitle = viewData.buttonTitle {
                    Button(buttonTitle) {
                        viewData.tryAgainHandler?()
                    }.foregroundColor(UIColor.link.color)
                        .padding()
                }
            }
        }

    }
 }
