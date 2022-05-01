//
//  ESPNMarvelHomeViewModel.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/29/22.
//

import Foundation
import SwiftUI

class ESPNMarvelHomeViewModel: ObservableObject {
    enum ViewState {
        case idle
        case loading
        case openingLink
    }
    
    @Published var state = ViewState.idle
    var loadedData: IssueModel?
    
    var navigateToIssueViewFlag: Bool {
        get {
            return state == .openingLink
        }
        set {
            // do nothing. Set via state object
        }
    }
    
    func resetView() {
        state = ViewState.idle
        loadedData = nil
    }
    
    func loadIssue(comicId: String) {
        let networkService = MarvelNetworkService()
        state = .loading
        networkService.requestIssue(comicId: comicId) { issueModel in
            
            DispatchQueue.main.async {
                self.loadedData = issueModel
                self.state = .openingLink
            }
        }
    }
}
