//
//  SwiftUIView.swift
//  
//
//  Created by Mohamed El-Shawarby on 26.05.22.
//

import SwiftUI
import SDWebImageSwiftUI

struct WebImageView: View {

    let url: URL?
    let placeholderName: String?

    private var placeHolderImage: Image {
        Image(placeholderName ?? "placeholder")
    }

    var body: some View {
        if let url = url {
            WebImage(url: url).placeholder(placeHolderImage)
                .resizable()
        } else {
            placeHolderImage
                .resizable()
        }
    }
}
