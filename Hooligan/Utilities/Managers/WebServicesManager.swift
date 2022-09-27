//
//  WebServicesManager.swift
//  Hooligan
//
//  Created by Luntu Mavukuza on 2022/09/27.
//

import Foundation
import Alamofire

enum ResponseErrorType: Error {
    case unauthorized(String?)
    case notFound(String?)
    case generic(String?)
    case noInternet
}

/**
 * Using swift 5.5 concurrency async await
 * Using AlamoreFire preffered `responseDecodable`
 */

class WebServicesManager<T: Codable> {
    
    enum OC_APIs {
        case severless
        case node
        case sanity
    }
    
    typealias WebServicesResponse = (result: T?, errorStatus: ResponseErrorType?)
    
    // MARK: - Instance variables
    private var loggable = true
    private let baseApiURL = "https://us-central1-dazn-sandbox.cloudfunctions.net"
    private var hasInternetConnection: Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    // MARK: - Mutators
    func disableLogging() {
        self.loggable = false
    }
    
    // MARK: - Serverless
    func GET(url: String,
             parameters: [String: Any]? = nil) async -> WebServicesResponse {
        let genericErrorMessage = NSLocalizedString("GENERAL_INTERNET_ERROR_MESSAGE", comment: "")
        var returnResponse: WebServicesResponse = (nil, ResponseErrorType.generic(genericErrorMessage))
        
        if hasInternetConnection {
            let fullUrl = "\(baseApiURL)\(url)"
            if loggable {
                JSONLogger.logServiceRequest(parameters,
                                             url: fullUrl,
                                             method: .get)
            }
            let result: WebServicesResponse = await withCheckedContinuation { continuation in
                AF.request(fullUrl,
                           method: .get,
                           parameters: parameters,
                           encoding: JSONEncoding.default).responseDecodable(of: T.self) { response in
                    continuation.resume(returning: self.handleResponse(response, for: .severless))
                }
            }
            returnResponse = result
        }
        return returnResponse
    }
    
    // MARK: - Private
    private func handleResponse(_ response: (DataResponse<T, AFError>),
                                for api: OC_APIs,
                                authenticated: Bool = true) -> WebServicesResponse {
        let genericErrorMessage = NSLocalizedString("GENERAL_INTERNET_ERROR_MESSAGE", comment: "")
        let genericErrorResponse: WebServicesResponse = (nil, ResponseErrorType.generic(genericErrorMessage))
        guard let statusCode = response.response?.statusCode else {
            debugPrint("No status code")
            return genericErrorResponse
        }
        if loggable {
            JSONLogger.logServiceResponse(response)
        }
        return handleSuccessResponse(response,
                                     statusCode: statusCode,
                                     genericErrorResponse: genericErrorResponse)
    }
    
    private func handleSuccessResponse(_ response: (DataResponse<T, AFError>),
                                       statusCode: Int,
                                       genericErrorResponse: WebServicesResponse) -> WebServicesResponse {
        if statusCode >= 200 && statusCode <= 299 {
            return (response.value, nil)
        } else {
            guard let data = response.data,
                  let jsonPayload = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let message = jsonPayload["message"] as? String else { return genericErrorResponse }
            if statusCode == 401 {
                return (nil, ResponseErrorType.unauthorized(message))
            } else if statusCode == 404 {
                return (nil, ResponseErrorType.notFound(message))
            } else {
                return (nil, ResponseErrorType.generic(message))
            }
        }
    }
}

