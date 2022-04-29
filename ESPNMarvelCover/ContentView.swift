//
//  ContentView.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/28/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding().onAppear(perform: testCode)
    }
    
    func testCode() {
        print("Running test")
        let networkService = MarvelNetworkService()
        networkService.requestIssue(comicId: "12386") { issueModel in
            print("Ran the service")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
