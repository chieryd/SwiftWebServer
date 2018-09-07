//
//  NetResponse.swift
//  COpenSSL
//
//  Created by HanDong Wang on 2018/8/17.
//

import PerfectHTTP

class NetResponse : NetData {
    var code : Int = 200;
    var message :String = "success";
    var data : Any = Dictionary<String,Any>();
    
    static let registerName = "NetResponse";
    override func getJSONValues() -> [String : Any] {
        return  [
            "code":code,
            "message":message,
            "data":data,
        ]
    }
    
    override func setJSONValues(_ values: [String : Any]) {
        self.code = getJSONValue(named: "code", from: values, defaultValue: 0);
        self.message = getJSONValue(named: "message", from: values, defaultValue: "");
        self.data = getJSONValue(named: "data", from: values, defaultValue: Dictionary<String,Any>());
    }
    
    func sendError(message:String) -> Void {
        self.code=0;
        self.message=message;
    }
    
    func sendData(data:Any) -> Void {
        self.code=200;
        self.message="success";
        self.data=data
    }
}

extension HTTPResponse {
    
    func sendError(message:String) -> Void {
        let response: NetResponse = NetResponse();
        response.sendError(message: message);
        var encodedString : String! = "";
        do {
            encodedString = try response.jsonEncodedString();
        }
        catch{
            
        }
        self.appendBody(string: encodedString);
        self.completed();
//        LogToFile("Error Message : \(message)");
    }
    
    func sendData(data : Any) -> Void {
        let response: NetResponse = NetResponse()
        let dict = data
        response.sendData(data: dict)
        var encodedString : String! = ""
        do {
            encodedString = try response.jsonEncodedString()
        }
        catch{
            
        }
        self.appendBody(string: encodedString)
        self.completed()
    }
}
