//
//  MD5+Strings.swift
//  ESPNMarvelCover
//
//  Created by Davis, R. Steven on 5/2/22.
//

import Foundation
import CryptoKit

extension Insecure.MD5 {
    static func stringHash(string: String) -> String {
        let hashDigest = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        return hashDigest.map({String(format: "%02hhx", $0)}).joined()
    }
}
