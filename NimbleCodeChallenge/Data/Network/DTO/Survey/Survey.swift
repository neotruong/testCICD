//
//  Survey.swift
//  NimbleCodeChallenge
//
//  Created by Neo Truong on 9/3/24.
//

import Foundation

struct SurveyResponseDTO: BaseDTO {
    let data: [SurveyDTO]
    let meta: MetaDTO
}

struct SurveyDTO: BaseDTO {
    let id: String
    let type: String
    let attributes: SurveyAttributesDTO
}

struct SurveyAttributesDTO: BaseDTO {
    let title: String
    let description: String
    let thankEmailAboveThreshold: String?
    let thankEmailBelowThreshold: String?
    let isActive: Bool
    let coverImageURL: String
    let createdAt: String
    let activeAt: String
    let inactiveAt: String?
    let surveyType: String

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case thankEmailAboveThreshold = "thank_email_above_threshold"
        case thankEmailBelowThreshold = "thank_email_below_threshold"
        case isActive = "is_active"
        case coverImageURL = "cover_image_url"
        case createdAt = "created_at"
        case activeAt = "active_at"
        case inactiveAt = "inactive_at"
        case surveyType = "survey_type"
    }
}

struct MetaDTO: BaseDTO {
    let page: Int
    let pages: Int
    let pageSize: Int
    let records: Int

    enum CodingKeys: String, CodingKey {
        case page
        case pages
        case pageSize = "page_size"
        case records
    }
}
