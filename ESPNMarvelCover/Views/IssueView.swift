//
//  IssueView.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 4/29/22.
//

import SwiftUI

struct IssueView: View {
    let issue: IssueModel?
    
    var body: some View {
        VStack {
            Text(issue?.name ?? "")
            GeometryReader { metrics in
                Image(uiImage: UIImage())
                    .resizable()
                    .frame(width: metrics.size.width * 0.75, height: metrics.size.width * 0.75 * 1024 / 633, alignment: .center)
                    .aspectRatio(CGSize(width: 633, height: 1024), contentMode: .fit)
                    .background(Color.gray)
                    .position(x: metrics.size.width/2, y: metrics.size.height/2)
                    
            }
                Text(issue?.description ?? "")
                Text("Issue display view")
        }.background(Color.red)
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
