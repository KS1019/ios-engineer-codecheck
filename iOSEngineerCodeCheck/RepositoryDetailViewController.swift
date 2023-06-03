import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchesLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!
    
    var searchRepositoryVC: SearchRepositoryViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let repo = searchRepositoryVC.repositories[searchRepositoryVC.index]
        
        languageLabel.text = "Written in \(repo["language"] as? String ?? "")"
        starsLabel.text = "\(repo["stargazers_count"] as? Int ?? 0) stars"
        watchesLabel.text = "\(repo["wachers_count"] as? Int ?? 0) watchers"
        forksLabel.text = "\(repo["forks_count"] as? Int ?? 0) forks"
        issuesLabel.text = "\(repo["open_issues_count"] as? Int ?? 0) open issues"
        setOwnerAvatar()
    }

    /// アバター画像を取得する
    func setOwnerAvatar(){
        
        let repo = searchRepositoryVC.repositories[searchRepositoryVC.index]
        
        titleLabel.text = repo["full_name"] as? String
        
        if let owner = repo["owner"] as? [String: Any] {
            if let imgURL = owner["avatar_url"] as? String {
                URLSession.shared.dataTask(with: URL(string: imgURL)!) { (data, res, err) in
                    let img = UIImage(data: data!)!
                    DispatchQueue.main.async {
                        self.imageView.image = img
                    }
                }.resume()
            }
        }
        
    }
}
