//
//  CDExtension.swift
//  WebService
//
//  Created by HanDong Wang on 2018/8/20.
//


import PerfectLib
import Foundation

#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif

// 使用shell脚本
func runProc(cmd: String, args: [String], read: Bool = false) throws -> String? {
    let envs = [("PATH", "/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin")]
    let proc = try SysProcess(cmd, args: args, env: envs)
    var ret: String?
    if read {
        var ary = [UInt8]()
        while true {
            do {
                guard let s = try proc.stdout?.readSomeBytes(count: 1024), s.count > 0 else {
                    break
                }
                ary.append(contentsOf: s)
            } catch PerfectLib.PerfectError.fileError(let code, _) {
                if code != EINTR {
                    break
                }
            }
        }
        ret = UTF8Encoding.encode(bytes: ary)
    }
    let res = try proc.wait(hang: true)
    if res != 0 {
        let s = try proc.stderr?.readString()
        throw  PerfectError.systemError(Int32(res), s!)
    }
    return ret
}


func shell(launchPath: String, arguments: [String]) -> String?
{
    let task = Process()
    task.launchPath = launchPath
    task.arguments = arguments
    
    let pipe = Pipe()
    task.standardOutput = pipe
    task.launch()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: String.Encoding.utf8)
    if let value = output, value.count > 0 {
        //remove newline character.
        let lastIndex = value.index(before: value.endIndex)
        return String(value[value.startIndex ..< lastIndex])
    }
    return output
}

// 这里配置一张表，当前系统可以直接索引路径
func systemSymbolPath(bySystemVersion: String, imageName: String) -> String? {
    let prePath: String = "/Users/handongwang/Library/Developer/Xcode/iOS DeviceSupport"
    let libSuffixPath: String = "Symbols/usr/lib"
    let frameworkSuffixPath: String = "Symbols/System/Library/Frameworks"
    
    var suffixPath = frameworkSuffixPath
    if imageName.hasPrefix("lib") {
        suffixPath = libSuffixPath
    }
    
    if bySystemVersion == "11.4.1" {
        return prePath + "/11.4.1 (15G77)/" + suffixPath
    }
    return nil
}
