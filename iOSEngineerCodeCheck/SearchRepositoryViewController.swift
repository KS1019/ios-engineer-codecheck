import UIKit

class SearchRepositoryViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var repositories: [[String: Any]] = []
    
    var urlSessionTask: URLSessionTask?
    var index: Int!
    
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
        urlSessionTask?.cancel()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchWord = searchBar.text else { return }
        
        if searchWord.count != 0 {
            guard let url = URL(string: "https://api.github.com/search/repositories?q=\(searchWord)") else { return }
            urlSessionTask = URLSession.shared.dataTask(with: url) { (data, res, err) in
                guard let data = data,
                      let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let items = obj["items"] as? [[String: Any]]  else { return }
                self.repositories = items
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        // タスクの再開（テーブルビューを更新する）
        urlSessionTask?.resume()
    }

    /// 画面遷移直前に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail" {
            guard let repositoryDetailVC = segue.destination as? RepositoryDetailViewController else { return }
            repositoryDetailVC.searchRepositoryVC = self
        }
    }

    /// Cell（レポジトリ）の数を返す
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    /// Cellの生成
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let repository = repositories[indexPath.row]
        cell.textLabel?.text = repository["full_name"] as? String ?? ""
        cell.detailTextLabel?.text = repository["language"] as? String ?? ""
        cell.tag = indexPath.row

        return cell
    }

    /// 画面遷移時に呼ばれる
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        performSegue(withIdentifier: "Detail", sender: self)
    }
}
