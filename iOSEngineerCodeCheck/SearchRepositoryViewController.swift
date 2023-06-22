import UIKit

class SearchRepositoryViewController: UITableViewController, UISearchBarDelegate {
    @IBOutlet weak private var searchBar: UISearchBar!

    private var repositories: [Repository] = []
    private var urlSessionTask: URLSessionTask?
    private var index: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.text = "GitHubのリポジトリを検索できるよー"
        searchBar.delegate = self
    }

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        // ↓こうすれば初期のテキストを消せる
        searchBar.text = ""
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let urlSessionTask = urlSessionTask else { return }
        urlSessionTask.cancel()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text,
              case .success(let task) = GitHubAPI.searchRepositories(for: searchWord, completion: { repositories in
                  self.repositories = repositories
                  DispatchQueue.main.async {
                      self.tableView.reloadData()
                  }
              }) else { return }
        task.resume()
        urlSessionTask = task
    }

    /// 画面遷移直前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let repositoryDetailVC = segue.destination as? RepositoryDetailViewController else { return }
            repositoryDetailVC.repo = repositories[index]
        }
    }

    /// Cell（レポジトリ）の数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    /// Cellの生成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Repository") as? RepositoryCell else { fatalError() }
        let repository = repositories[indexPath.row]
        cell.titleLabel.text = repository.fullName
        cell.detailLabel.text = repository.language ?? ""
        cell.tag = indexPath.row
        return cell
    }

    /// 画面遷移時に呼ばれる
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}

class RepositoryCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
}

