//
//  GetData.swift
//  WebService
//
//  Created by HanDong Wang on 2018/8/22.
//

import PerfectHTTP
import Foundation
import PerfectMongoDB

class GetData: NetRequest {
    // 从当前的数据库中读出数据
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        // 容器数组
        let arr = NSMutableArray()
        
        if let findResult = collection.find() {
            for element in findResult {
                arr.add(element.asString)
            }
            if arr.count > 0 {
                response.sendData(data: arr)
            }
            else {
                response.sendError(message: "数据库中没有数据")
            }
        }
        else {
            response.sendError(message: "数据库中没有数据")
        }
    }
}

