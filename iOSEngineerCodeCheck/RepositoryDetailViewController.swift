import UIKit

class RepositoryDetailViewController: UIViewController {
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var languageLabel: UILabel!
    @IBOutlet weak private var starsLabel: UILabel!
    @IBOutlet weak private var watchesLabel: UILabel!
    @IBOutlet weak private var forksLabel: UILabel!
    @IBOutlet weak private var issuesLabel: UILabel!

    public var repo: Repository!

    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        setOwnerAvatar()
    }

    /// ラベルを設定する
    private func setLabels() {
        languageLabel.text = repo.language != nil ? "Written in \(repo.language!)" : ""
        starsLabel.text = "\(repo.stargazersCount) stars"
        watchesLabel.text = "\(repo.watchersCount) watchers"
        forksLabel.text = "\(repo.forksCount) forks"
        issuesLabel.text = "\(repo.openIssuesCount) open issues"
        titleLabel.text = repo.fullName
    }

    /// アバター画像を設定する
    private func setOwnerAvatar() {
        GitHubAPI.getAvatarImage(for: repo) { image in
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}
