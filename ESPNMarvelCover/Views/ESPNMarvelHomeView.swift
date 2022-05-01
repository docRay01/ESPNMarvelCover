//
//  ESPNMarvelHomeView.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/29/22.
//

import SwiftUI

struct ESPNMarvelHomeView: View {
    @StateObject var viewModel = ESPNMarvelHomeViewModel()
    
    @State private var issueInputFieldValue: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Data input view")
                TextField("ComicId", text: $issueInputFieldValue)
                    .textFieldStyle(.roundedBorder)
                    .padding(EdgeInsets(top: 10,
                                        leading: 35,
                                        bottom: 10,
                                        trailing: 35))
                    .accessibilityIdentifier("comicId field")
                Button {
                    viewModel.loadIssue(comicId: issueInputFieldValue)
                } label: {
                    Text("Excelsior!")
                }
                .buttonStyle(.automatic)
                .accessibilityIdentifier("submit button")
                
                NavigationLink(destination: IssueView(issue: viewModel.loadedData),
                               isActive: $viewModel.navigateToIssueViewFlag) {
                    EmptyView()
                }
            }
        }
    }
}

struct ESPNMarvelHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ESPNMarvelHomeView()
    }
}
