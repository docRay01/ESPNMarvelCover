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
            }.overlay(
                VStack {
                    Text("Loading...")
                        .font(.title)
                }.frame(width: 700,
                        height: 150,
                        alignment: .center)
                    .background(Color.init(.sRGBLinear,
                                           red: 0.7,
                                           green: 0.7,
                                           blue: 0.7,
                                           opacity: 0.6))
                    .opacity(viewModel.state == .loading ? 1 : 0)
            )
        }
    }
}

struct ESPNMarvelHomeView_Previews: PreviewProvider {
    static var previews: some View {
        ESPNMarvelHomeView()
    }
}
