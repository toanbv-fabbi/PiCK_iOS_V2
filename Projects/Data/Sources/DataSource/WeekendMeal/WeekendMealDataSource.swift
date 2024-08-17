import Foundation

import RxSwift
import Moya
import RxMoya

import Core
import AppNetwork
import Domain

protocol WeekendMealDataSource {
    func weekendMealApply(status: String) -> Completable
    func weekendMealCheck() -> Single<Response>
}

class WeekendMealDataSourceImpl: BaseDataSource<WeekendMealAPI>, WeekendMealDataSource {
    func weekendMealApply(status: String) -> Completable {
        return request(.weekendMealApply(status: status))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    func weekendMealCheck() -> Single<Response> {
        return request(.weekendMealCheck)
            .filterSuccessfulStatusCodes()
    }
    
    
}
