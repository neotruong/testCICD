//
//  SurveyData.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation

struct SurveyItem {
    let coverImage: String
    let name: String
    let description: String
    
    func getURL() -> URL? {
        return URL(string: coverImage)
    }
}

struct SurveyData {
    var listSurvey: [SurveyItem]
    var pageSize: Int
    var pageNumber: Int
    let maxPage: Int
}
