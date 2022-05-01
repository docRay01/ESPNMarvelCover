//
//  IssueView.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/29/22.
//

import SwiftUI

struct IssueView: View {
    let issue: IssueModel
    
    var body: some View {
        Text("Issue display view")
    }
    
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        let issue = IssueModel(id: "12345",
                               name: "TestIsssue",
                               imageURLString: "https://source.unsplash.com/user/c_v_r/100x100", description: "This is a test string. Lorem ipsum! Excelsior!")
        
        IssueView(issue: issue)
    }
}
