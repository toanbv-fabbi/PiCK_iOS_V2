import Foundation

import Moya

import Core
import Domain
import AppNetwork

public enum AuthAPI {
    case login(req: LoginRequestParams)
//    case refreshToken(refreshToken: String)
    case refreshToken
}

extension AuthAPI: PiCKAPI {
    public typealias ErrorType = PiCKError
    
    public var urlType: PiCKURL {
        .user
    }
    
    public var urlPath: String {
        switch self {
            case .login:
                return "/login"
            case .refreshToken:
                return "/refresh"
        }
    }
    
    public var method: Moya.Method {
        switch self {
            case .login:
                return .post
            case .refreshToken:
                return .put
        }
    }
    
    public var task: Moya.Task {
        switch self {
            case let .login(req):
                return .requestParameters(
                    parameters: [
                        "account_id": req.accountID,
                        "password": req.password
                    ],
                    encoding: JSONEncoding.default
                )
        default:
            return .requestPlain
        }
    }
    
    public var pickHeader: tokenType {
        switch self {
        case .refreshToken:
            return .refreshToken
        default:
            return .tokenIsEmpty
        }
    }

    public var errorMap: [Int : PiCKError]? {
        return nil
    }

}