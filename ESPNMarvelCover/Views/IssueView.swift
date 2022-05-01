//
//  IssueView.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/29/22.
//

import SwiftUI

struct IssueView: View {
    let issue: IssueModel?
    @StateObject var imageLoader = ImageLoader()
    
    var body: some View {
        VStack {
            Text(issue?.name ?? "")
            Image(uiImage: imageLoader.image(urlString: issue?.imageURLString ?? ""))
                    .resizable()
                    .aspectRatio(CGSize(width: 633, height: 1024), contentMode: .fit)
                    .background(Color.gray)
                    .layoutPriority(1)
            .padding(EdgeInsets(top: 10,
                                 leading: 80,
                                 bottom: 10,
                                 trailing: 80))
            
            Text(issue?.description ?? "")
            Spacer()
        }
    }
    
}

struct IssueView_Previews: PreviewProvider {
    static var previews: some View {
        let issue = IssueModel(id: "12345",
                               name: "TestIsssue",
                               imageURLString: "https://source.unsplash.com/user/c_v_r/100x100", description: "This is a test string. \n \nLorem ipsum! Excelsior!")
        
        IssueView(issue: issue)
    }
}
