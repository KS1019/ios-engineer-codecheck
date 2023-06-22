import Foundation
import UIKit.UIImage

struct GitHubAPI {
    static func searchRepositories(for searchWord: String, completion: @escaping (_ repositories: [Repository]) -> Void) -> Result<URLSessionDataTask, GitHubAPIError> {
        guard searchWord.count > 0 else { return .failure(.searchWordTooShort) }
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else { return .failure(.cannotFormURL(invalidURL: "https://api.github.com/search/repositories?q=\(searchWord)")) }

        let task = URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data,
                  let result = try? JSONDecoder().decode(RepoSearchResultItem.self, from: data) else { return }
            completion(result.items)
        }

        return .success(task)
    }

    static func getAvatarImage(for repo: Repository, completion: @escaping (_ image: UIImage) -> Void) {
        guard let avatarURL = URL(string: repo.owner.avatarURL) else { return }
        URLSession.shared.dataTask(with: avatarURL) { (data, res, err) in
            guard let data =  data, let image = UIImage(data: data) else { return }
            completion(image)
        }
        .resume()
    }

    enum GitHubAPIError: LocalizedError {
        case searchWordTooShort
        case cannotFormURL(invalidURL: String)
        var errorDescription: String? {
            switch self {
                case .searchWordTooShort:
                    return "Search word is too short"
                case .cannotFormURL(let invalid):
                    return "Valid URL cannot be formed. Invalid URL: \(invalid)"
            }
        }
    }
}