import PerfectHTTP
import PerfectHTTPServer


// 注册您自己的路由和请求／响应句柄
var routes = Routes()

let handler = {
    (request: HTTPRequest, response: HTTPResponse) in
    
    print("params")
    print("-----------")
    print(request.postParams)
    
    print("postBodyBytes")
    print("-----------")
    print(request.postBodyBytes ?? "")
    
    print("postBodyString")
    print("-----------")
    print(request.postBodyString ?? "")
    
    print("postFileUploads")
    print("-----------")
    print(request.postFileUploads ?? "")
    
    
    if let decodedJson = try? request.postBodyString?.jsonDecode() as? [String: String] {
        let callStack = decodedJson!["callStack"]
        let type = decodedJson!["type"]
        let name = decodedJson!["name"]
        let reason = decodedJson!["reason"]
        let appInfo = decodedJson!["appInfo"]
        let topVC = decodedJson!["topVC"]
        
        
        response.setHeader(.contentType, value: "application/json")
        response.appendBody(string: "{\"a\":\"b\"}")
            .completed()
    }
    else {
        
    }
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: "{\"a\":\"b\"}")
        .completed()
}

let putHandler = {
    (request: HTTPRequest, response: HTTPResponse) in
    
    print("params")
    print("-----------")
    print(request.postParams)
    
    print("postBodyBytes")
    print("-----------")
    print(request.postBodyBytes ?? "")
    
    print("postBodyString")
    print("-----------")
    print(request.postBodyString ?? "")
    
    print("postFileUploads")
    print("-----------")
    print(request.postFileUploads ?? "")
    
    if let decodedJson = try? request.postBodyString?.jsonDecode() as? [String: String] {
        let callStack = decodedJson!["callStack"]
        let type = decodedJson!["type"]
        let name = decodedJson!["name"]
        let reason = decodedJson!["reason"]
        let appInfo = decodedJson!["appInfo"]
        let topVC = decodedJson!["topVC"]
        
        
        response.setHeader(.contentType, value: "application/json")
        response.appendBody(string: "{\"a\":\"b\"}")
            .completed()
    }
    else {
        
    }
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: "{\"a\":\"b\"}")
        .completed()
}

routes.add(method: .put, uri: "/put", handler: putHandler)

routes.add(method: .post, uri: "/upload", handler: handler)

routes.add(method: .get, uri: "/temp") {
    request, response in
    
    response.setHeader(.contentType, value: "application/json")
    response.appendBody(string: "{\"a\":\"b\"}")
        .completed()
    //    response.setHeader(.contentType, value: "text/html")
    //    response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!</body></html>")
    //        .completed()
}

do {
    // 启动HTTP服务器
    try HTTPServer.launch(
        .server(name: "www.example.ca", port: 8181, routes: routes))
} catch {
    fatalError("\(error)") // fatal error launching one of the servers
}
