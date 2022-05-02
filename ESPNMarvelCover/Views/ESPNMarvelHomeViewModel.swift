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
        networkService.requestIssue(comicId: comicId) { issueResponse in
            switch issueResponse {
            case .success(let issue):
                DispatchQueue.main.async {
                    self.loadedData = issue
                    self.state = .openingLink
                }
            case .failure:
                DispatchQueue.main.async {
                    self.loadedData = nil
                    self.state = .idle
                }
            case .error(_):
                DispatchQueue.main.async {
                    self.loadedData = nil
                    self.state = .idle
                }
            }
        }
    }
}
