//
//  ViesureiOSTaskApp.swift
//  ViesureiOSTask
//
//  Created by Mohamed El-Shawarby on 23.06.22.
//

import SwiftUI

@main
struct ViesureiOSTaskApp: App {

    var body: some Scene {
        WindowGroup {
            ArticlesView(viewModel: ArticlesViewModel())
        }
    }
}
