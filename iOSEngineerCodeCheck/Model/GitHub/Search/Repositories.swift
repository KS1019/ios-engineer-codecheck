// Codable representation of JSON definition for GitHub Search API to search repositories
// https://docs.github.com/en/rest/search?apiVersion=2022-11-28#search-repositories

import Foundation

public struct RepoSearchResultItem: Codable {
    let items: [Repository]
}

public struct Repository: Codable {
    let owner: User
    let language: String?
    let fullName: String
    let stargazersCount: Int
    let watchersCount: Int
    let forksCount: Int
    let openIssuesCount: Int

    enum CodingKeys: String, CodingKey {
        case owner, language
        case fullName = "full_name"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case forksCount = "forks_count"
        case openIssuesCount = "open_issues_count"
    }
}

public struct User: Codable {
    let avatarURL: String

    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
    }
}
