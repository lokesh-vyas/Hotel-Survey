//
//  NetworkWrapper.swift
//  HotelSurvey
//
//  Created by Mayank on 10/10/17.
//  Copyright © 2017 Mayank. All rights reserved.
//

import Foundation
import Alamofire

private let _sharedInstance = NetworkWrapper()

class NetworkWrapper {
    
    fileprivate init(){}
    
    static var sharedInstance: NetworkWrapper {
        return _sharedInstance
    }
    
    fileprivate let restClient = RestClient()
    
    func getSurveyDetailData(page:Int, perPage:Int, onSuccess:@escaping (Any)->(), onFailure:@escaping (String)->() ) {
        let (apiBuilder, params) = APIBuilder.buildSurveyDetailAPI(page:page, perPage:perPage)
        restClient.request(apiBuilder.getMethod(), urlString: apiBuilder.getUrl(), parameters: params, onSuccess: onSuccess, onFailure: onFailure)
    }
    
    func getOAuthData(username:String, password:String, onSuccess:@escaping (Any)->(), onFailure:@escaping (String)->() ) {
        let (apiBuilder, params) = APIBuilder.buildOAuthAPI(username:username, password:password)
        restClient.request(apiBuilder.getMethod(), urlString: apiBuilder.getUrl(), parameters: params, onSuccess: onSuccess, onFailure: onFailure)
    }
}

private class RestClient {
    
        func request(_ methodStr:MethodType, urlString:String, parameters params:[String : Any]? = nil, headers:[String:String]? = nil, timeoutInterval: TimeInterval = 60, encodingOption: ParameterEncoding? = nil, onSuccess: @escaping (Any) -> (), onFailure: @escaping (String) -> ()) {
            
            let encoding = encodingOption ?? URLEncoding(destination: .methodDependent)
            
            let parameterFormat:Dictionary<String, Any>? = params
            
            // Request completion block
            let completionBlock = { [weak self] (response: DataResponse<Any>) in
                
                guard self != nil else {
                    return
                }
                
                print(response.request?.url ?? "")
                print(parameterFormat ?? "")
                NSLog("response is \(String(describing: response.response))")
                
                switch response.result {
                case .success:
                    
                    if let json = response.result.value {
                        let JSON = json
                        onSuccess(JSON)
                    }else {
                        print("response: \(response.debugDescription)\n")
                        onFailure(response.error?.localizedDescription ?? "Something went wrong")
                    }
                case .failure(_):
                    onFailure(response.error?.localizedDescription ?? "Something went wrong")
                }
            }
            
            guard let alamoMethod = HTTPMethod(rawValue: methodStr.rawValue) else {
                onFailure("Something went wrong")
                return
            }
            
            
            _ = Alamofire.request(urlString, method: alamoMethod, parameters: parameterFormat, encoding: encoding, headers: headers).validate().responseJSON { (response) in
                completionBlock(response)
                print(response)
            }
        }
    }
