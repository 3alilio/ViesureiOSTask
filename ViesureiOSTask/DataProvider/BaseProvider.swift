//
//  BaseProvider.swift
//  
//
//  Created by Mohamed El-Shawarby on 23.6.22.
//

import Foundation
import Moya
import Alamofire

class BaseProvider<Target: TargetType>: MoyaProvider<Target> {

   override init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
                 requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
                 stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider.neverStub, callbackQueue: DispatchQueue? = nil,
                 session: Session = MoyaProvider<Target>.defaultAlamofireSession(), plugins: [PluginType] = [], trackInflights: Bool = false) {

       #if DEBUG
       let plugins = [NetworkLoggerPlugin(configuration: .init(formatter: .init(), output: { (_, array) in
           if let log = array.first {
               print(log)
           }
       }, logOptions: .formatRequestAscURL))]
       #endif

       super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, callbackQueue: callbackQueue,
                  session: session, plugins: plugins, trackInflights: trackInflights)
   }
}
