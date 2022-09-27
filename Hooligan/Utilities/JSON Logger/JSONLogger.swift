//
//  JSONLogger.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation
import Alamofire

class JSONLogger {
    
    static func logServiceRequest(_ requestJson: [String: Any]?,
                                  url: String,
                                  method: HTTPMethod) {
        guard let safeRequestJson = requestJson,
              let jsonData = try? JSONSerialization.data(withJSONObject: safeRequestJson, options: .prettyPrinted) else {
            debugPrint(NSString(string: ">>> REQUEST \(url) \n METHOD: \(method.rawValue)"))
            return
        }
        let jsonString = NSString(string: String(decoding: jsonData, as: UTF8.self))
        debugPrint(NSString(string: ">>> REQUEST \(url) \n METHOD: \(method.rawValue) \n BODY: \(jsonString)"))
    }
    
    static func logServiceResponse(_ response: AFDataResponse<Any>) {
        guard let url = response.request?.url?.relativeString,
              let statusCode = response.response?.statusCode,
              let data = response.data,
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            debugPrint("Error in getting url, status code and data")
            return
        }
        
        let jsonString = NSString(string: String(decoding: jsonData, as: UTF8.self))
        debugPrint(NSString(string: ">>> RESPONSE [\(String(statusCode))] \(url) \n METHOD: \(response.request?.httpMethod ?? "N/A") \n BODY: \n \(jsonString)"))
    }
    
    static func logServiceResponse<T: Codable>(_ response: DataResponse<T, AFError>) {
        guard let url = response.request?.url?.relativeString,
              let statusCode = response.response?.statusCode,
              let data = response.data,
              let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),
              let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            debugPrint("Error in getting url, status code and data")
            return
        }
        
        let jsonString = NSString(string: String(decoding: jsonData, as: UTF8.self))
        debugPrint(NSString(string: ">>> RESPONSE [\(String(statusCode))] \(url) \n METHOD: \(response.request?.httpMethod ?? "N/A") \n BODY: \n \(jsonString)"))
    }
    
    static func logDictionaryData(_ dictionary: [String: Any]?) {
        guard let safeDictionary = dictionary,
              let jsonData = try? JSONSerialization.data(withJSONObject: safeDictionary,
                                                         options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        debugPrint(NSString(string: jsonString))
    }
    
    static func logDictionaryData(_ dictionaryList: [[String: Any]]?) {
        guard let safeDictionaryList = dictionaryList,
              let jsonData = try? JSONSerialization.data(withJSONObject: safeDictionaryList,
                                                         options: .prettyPrinted),
              let jsonString = String(data: jsonData, encoding: .utf8) else { return }
        debugPrint(NSString(string: jsonString))
    }
}
