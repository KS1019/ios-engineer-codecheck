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
        prepareLabels()
        setOwnerAvatar()
    }

    func prepareLabels() {
        languageLabel.text = repo.language != nil ? "Written in \(repo.language!)" : ""
        starsLabel.text = "\(repo.stargazersCount) stars"
        watchesLabel.text = "\(repo.watchersCount) watchers"
        forksLabel.text = "\(repo.forksCount) forks"
        issuesLabel.text = "\(repo.openIssuesCount) open issues"
        titleLabel.text = repo.fullName
    }

    /// アバター画像を設定する
    func setOwnerAvatar() {
        GitHubAPI.getAvatarImage(for: repo) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
