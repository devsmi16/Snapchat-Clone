import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var feedImageView: UIView!
    @IBOutlet weak var feedUsernameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
