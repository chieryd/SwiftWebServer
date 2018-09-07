//
//  NetRequest.swift
//  COpenSSL
//
//  Created by HanDong Wang on 2018/8/17.
//

import PerfectHTTP

#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

class NetRequest {
    
}

extension HTTPRequest {
    
    func paramSafe(name: String) -> String! {
        if let param = self.param(name: name) {
            return param
        }
        else{
            return "";
        }
    }
}
