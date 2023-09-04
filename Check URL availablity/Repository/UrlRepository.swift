//
//  UrlRepository.swift
//  Check URL availablity
//
//  Created by Reza Sharifi on 9/1/23.
//

import Foundation

protocol UrlRepository {
    func checkAvailablity(of url: String, callBack: @escaping (UrlModel) -> ())
    func getAllCheckedUrls(callBack: @escaping ([UrlModel]) -> ())
    func checkAvailablityOf(all urls: [String], completion: @escaping ([UrlModel]) -> ())
    func getSearchedUrls(with url: String) -> [UrlModel]
    func delete(url: UrlModel)
}
