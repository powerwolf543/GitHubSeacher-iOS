//
//  SeachUserFetcher.swift
//  GitHubSeacher
//
//  Created by NixonShih on 2019/6/22.
//  Copyright © 2019 NixonShih. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPError: Error {
    case connection(reason: Error)
    case decode(reason: Error)
    case empty
}

protocol SeachUserFetcherSpec {
    typealias SeachUserFetcherCompletionHandler = (Swift.Result<PaginationResponse<[UserModel]>, HTTPError>) -> ()
    func fetchForPaginationResponse(query: SeachUserFetcher.QueryModel, completionHandler: @escaping SeachUserFetcherCompletionHandler)
}

struct SeachUserFetcher: SeachUserFetcherSpec {
    
    let url = "https://api.github.com/search/users"
    
    struct QueryModel {
        let page: UInt
        let query: String
    }
    
    func fetchForPaginationResponse(query: QueryModel, completionHandler: @escaping SeachUserFetcherCompletionHandler) {
        _fetchForPaginationResponse(query: query) { (result) in
            DispatchQueue.main.async { completionHandler(result) }
        }
    }
    
    private func _fetchForPaginationResponse(query: QueryModel, completionHandler: @escaping SeachUserFetcherCompletionHandler) {
        request(url, method: .get, parameters: ["q": query.query, "page": query.page], encoding: URLEncoding.default).response(queue: .global()) { (response) in
            
            if let error = response.error {
                completionHandler(.failure(.connection(reason: error)))
                print("⚡️【Failure】 \(response.request?.url?.absoluteString ?? "")\n\(error)")
                return
            }
            
            guard let data = response.data else {
                completionHandler(.failure(.empty))
                print("⚡️【Failure】 \(response.request?.url?.absoluteString ?? "")\nNo data")
                return
            }
            
            do {
                let dataModel = try JSONDecoder().decode(ApiSearchUserModel.self, from: data)
                let headers = response.response?.allHeaderFields as? [String: String]
                let hasNext = GitHubPaginationHeaderParser(headers: headers).hasNext
                let baseModel = PaginationResponse<[UserModel]>(
                    currentPage: query.page,
                    hasMore: hasNext,
                    dataModel: dataModel.items
                )
                completionHandler(.success(baseModel))
                print("⚡️【Success】 \(response.request?.url?.absoluteString ?? "")")
            } catch {
                completionHandler(.failure(.decode(reason: error)))
                print("⚡️【Failure】 \(response.request?.url?.absoluteString ?? "")\n\(error)")
            }
        }
    }
}

struct GitHubPaginationHeaderParser {
    
    init(headers: [String: String]?) {
        hasNext = checkHasNext(with: headers)
    }
    
    private(set) var hasNext: Bool = false
    
    // MARK: private
    
    private func checkHasNext(with headers: [String: String]?) -> Bool {
        guard let linkText = headers?["Link"] else { return false }
        let infos = linkText.split(separator: " ")
        for i in 0..<infos.count where i % 2 == 1 {
            guard infos[i].contains("next") else { continue }
            return true
        }
        return false
    }
}
