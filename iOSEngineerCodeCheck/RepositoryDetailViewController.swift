import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var watchesLabel: UILabel!
    @IBOutlet weak var forksLabel: UILabel!
    @IBOutlet weak var issuesLabel: UILabel!

    var repo: Repository!

    override func viewDidLoad() {
        super.viewDidLoad()

        languageLabel.text = repo.language != nil ? "Written in \(repo.language!)" : ""
        starsLabel.text = "\(repo.stargazersCount) stars"
        watchesLabel.text = "\(repo.watchersCount) watchers"
        forksLabel.text = "\(repo.forksCount) forks"
        issuesLabel.text = "\(repo.openIssuesCount) open issues"
        setOwnerAvatar()
    }

    /// アバター画像を設定する
    func setOwnerAvatar() {
        titleLabel.text = repo.fullName
        
        guard let avatarURL = URL(string: repo.owner.avatarURL) else { return }
        URLSession.shared.dataTask(with: avatarURL) { (data, res, err) in
            guard let data =  data, let img = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageView.image = img
            }
        }.resume()
    }
}
