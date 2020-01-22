//
//  ApiManager.swift
//  FishWorld
//
//  Created by Yura Granchenko on 14.11.2019.
//  Copyright © 2019 GYS. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire
import RxSwift
import RxAlamofire

private let timeOutInterval = 30.0

enum APIManager: URLRequestConvertible {
    
    case allNews([String: Any]),
    newNews([String: Any]),
    oldNews([String: Any])
    
    public func asURLRequest() throws -> URLRequest {
        
        var disposeBag = DisposeBag()
        let headers: [String: String]? = nil
        
        var method: HTTPMethod {
            switch self {
            case .allNews,
                 .newNews,
                 .oldNews:
                return .get
            }
        }
        
        let parameters: ([String: Any]?) = {
            switch self {
            case .allNews(let parameters),
                 .newNews(let parameters),
                 .oldNews(let parameters):
                return parameters
            }
        }()

        let url: URL = {
            let query: String?
            switch self {
            case .allNews:
                query = "get-initial-news"
            case .newNews:
                query = "get-updated-news"
            case .oldNews:
                query = "get-previous-news"
            }
            
            var URL = Foundation.URL(string: Constants.baseURL)!
            if let query = query {
                URL = URL.appendingPathComponent(query)
            }
            return URL
        }()
        
        Logger.warrning("REQUEST for \n\t url - \(url)\n\t method - \(method)\n\t parameters - " +
            "\(parameters ?? [:])")
        #if DEBUG
        Logger.warrning("header - \(headers ?? [:])")
        #endif
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.timeoutInterval = timeOutInterval
        
        if let headers = headers {
            for (headerField, headerValue) in headers {
                urlRequest.setValue(headerValue, forHTTPHeaderField: headerField)
            }
        }
        
        switch self {
        case .allNews:
            return try URLEncoding(arrayEncoding: .noBrackets).encode(urlRequest, with: parameters)
        default:
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
    }
    public func json(_ file: Any = #file,
                     function: Any = #function,
                     line: Int = #line) -> RxSwift.Observable<JSON> {
        return RxAlamofire.request(self)
            .observeOn(MainScheduler.instance)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .responseJSON()
            .catchError({ (error) -> Observable<DataResponse<Any>> in
                Logger.error("API error for \n\t \(error.localizedDescription)")
                return Observable.error(error)
            })
            .retry(3)
            .share(replay: 1)
            .flatMapLatest { response -> RxSwift.Observable<JSON> in
                var errorDescription = ""
                var errorReason = ""
                if case let .failure(error) = response.result {
                    if let error = error as? AFError {
                        switch error {
                        case .invalidURL(let url):
                            errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                        case .parameterEncodingFailed(let reason):
                            errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .multipartEncodingFailed(let reason):
                            errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .responseValidationFailed(let reason):
                            errorDescription = "Response validation failed: " +
                            "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                errorDescription = "Downloaded file could not be read"
                            case .missingContentType(let acceptableContentTypes):
                                errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                            case .unacceptableContentType(let acceptableContentTypes,
                                                          let responseContentType):
                                errorDescription = "Response content type: " +
                                    "\(responseContentType) " + "was unacceptable: " +
                                "\(acceptableContentTypes)"
                            case .unacceptableStatusCode(let code):
                                errorDescription = "Response status code was unacceptable: " + "\(code)"
                            }
                        case .responseSerializationFailed(let reason):
                            errorDescription = "Response serialization failed: " +
                            "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        }
                        errorDescription =  "Underlying error: " +
                        "\(error.underlyingError ?? RxError.unknown)"
                    } else if let error = error as? URLError {
                        errorDescription = "URLError occurred: " + "\(error)"
                    } else {
                        errorDescription = "Unknown error: " + "\(error)"
                    }
                    Logger.error("API error for \n\t [\((file as! NSString).lastPathComponent):" +
                        "\(line)] \(function):\n\t" + errorDescription + errorReason)
                    return Observable.error(error)
                }
                Logger.verbose("RESPONSE by request - \(response.request?.url?.absoluteString ?? "")" +
                    "\n\t [\((file as! NSString).lastPathComponent): \(line)] \(function): " +
                    "RESPONSE - \(response) \n\t\(response.timeline)")
                let json = JSON(response.result.value ?? NSNull())
                return Observable.just(json)
        }
    }
    
    public func data(_ file: Any = #file,
                     function: Any = #function,
                     line: Int = #line) -> RxSwift.Observable<Data> {
        return RxAlamofire.requestData(self)
            .catchError { error in
                Logger.error("API error for \n\t \(error.localizedDescription)")
                return Observable.error(error)
            }
            .share(replay: 1)
            .flatMapLatest { response -> RxSwift.Observable<Data> in
                guard 200 ... 299 ~= response.0.statusCode else {
                    Logger.error("API error for \n\t [\((file as! NSString).lastPathComponent):" +
                        "\(line)] \(function):\n\t" + "status code: \(response.0.statusCode)")
                    return Observable.error( NSError(domain: "Error status",
                                                     code: response.0.statusCode, userInfo: nil))
                }
                Logger.verbose("RESPONSE by request - \(response.0.url?.absoluteString ?? "")" +
                    " \n\t [\((file as! NSString).lastPathComponent): \(line)] \(function): " +
                    "RESPONSE - \(response)")
                return Observable.just(response.1)
        }
    }
    
    public func response(_ file: Any = #file,
                         function: Any = #function,
                         line: Int = #line) -> RxSwift.Observable<(HTTPURLResponse, String)> {
        return RxAlamofire.requestString(self)
            .catchError { error in
                Logger.error("API error for \n\t \(error.localizedDescription)")
                return Observable.error(error)
            }
            .share(replay: 1)
            .flatMapLatest { response, string -> RxSwift.Observable<(HTTPURLResponse, String)> in
                Logger.verbose("RESPONSE by request - \(response.url?.absoluteString ?? "")" +
                    "\n\t [\((file as! NSString).lastPathComponent): \(line)] \(function): " +
                    "RESPONSE - \(response)")
                guard 200 ... 299 ~= response.statusCode else {
                    Logger.error("API error for \n\t [\((file as! NSString).lastPathComponent):" +
                        "\(line)] \(function):\n\t" + "status code: \(response.statusCode)")
                    return Observable.error( NSError(domain: "Error status",
                                                     code: response.statusCode,
                                                     userInfo: nil))
                }
                return Observable.just((response, string))
        }
    }
}
