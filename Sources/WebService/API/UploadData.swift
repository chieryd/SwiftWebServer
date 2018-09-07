//
//  UploadData.swift
//  COpenSSL
//
//  Created by HanDong Wang on 2018/8/17.
//
import PerfectHTTP
import Foundation
import PerfectMongoDB

class UploadData: NetRequest {
    public static func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        print(request.postFileUploads ?? "nothing")
        
        func errorHandler(response: HTTPResponse) {
            response.sendError(message: "数据解析错误")
        }
        
        if let uploads = request.postFileUploads, uploads.count > 0 {
            // 当前测试中智慧传递一个文件
            if let upload = uploads.first {
                print(upload.tmpFileName)
                if let data = NSData.init(contentsOfFile: upload.tmpFileName) {
                    if let dict = try? JSONSerialization.jsonObject(with: data as Data, options: .mutableContainers), let dictObject = dict as? NSDictionary {
                        // 数据解析成功，使用命令行解析数据
                        if let stackInfoArray = dictObject["stackInfo"] as? NSArray,
                            stackInfoArray.count > 0,
                            let arch = dictObject["arch"] as? String,
                            let systemVersion = dictObject["systemVersion"] as? String {
                            let mutableArray = NSMutableArray()
                            for info in stackInfoArray {
                                if let infoDict = info as? [String : String], let nameString = infoDict["name"],
                                    let imageAddress = infoDict["imageAddress"], let strStackAddress = infoDict["strStackAddress"]{
                                    if let systemSymbolPath = systemSymbolPath(bySystemVersion: systemVersion, imageName: nameString),
                                        systemSymbolPath.count > 0 {
                                        // 系统文件中找符号文件
                                        if let findPath = shell(launchPath: "/usr/bin/find", arguments: ["\(systemSymbolPath)" , "-iname" , "\(nameString)"]), findPath.count > 0 {
                                            // 这里需要去除换行符
                                            print("atos -arch arm64 -o \(findPath) -l \(imageAddress) \(strStackAddress)")
                                            if let output = shell(launchPath: "/usr/bin/atos", arguments: ["-arch" , "\(arch)" , "-o" , "\(findPath)" , "-l" , "\(imageAddress)" , "\(strStackAddress)"]) {
                                                mutableArray.add(["name": nameString, "symbolString": output])
                                            }
                                        }
                                        else {
                                            if let output = shell(launchPath: "/usr/bin/atos", arguments: ["-arch" , "\(arch)" , "-o" , "/Users/handongwang/Desktop/TestCrashFile/TestCrash.app.dSYM/Contents/Resources/DWARF/TestCrash" , "-l" , "\(imageAddress)" , "\(strStackAddress)"]) {
                                                mutableArray.add(["name": nameString, "symbolString": output])
                                            }
                                        }
                                    }
                                }
                            }
                            if mutableArray.count > 0 {
                                if let newValue:NSMutableDictionary = dictObject.mutableCopy() as? NSMutableDictionary {
                                    newValue["stackInfo"] = mutableArray
                                    print(newValue)
                                    if let value = newValue as? [String : Any?] {
                                        // 插入到数据库中
                                        print(collection.insert(documents: [BSON.init(map: value)]))
                                        response.sendData(data: ["staus": "OK"])
                                    }
                                    else {
                                        errorHandler(response: response)
                                    }
                                }
                                else {
                                    errorHandler(response: response)
                                }
                            }
                            else {
                                errorHandler(response: response)
                            }
                        }
                        else {
                            errorHandler(response: response)
                        }
                    }
                    else {
                        errorHandler(response: response)
                    }
                }
                else {
                    errorHandler(response: response)
                }
            }
            else {
                errorHandler(response: response)
            }
        }
        else {
            errorHandler(response: response)
        }
    }
}
