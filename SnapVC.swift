import UIKit
import ImageSlideshowKingfisher
import Firebase
import ImageSlideshow

class SnapVC: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var selectedSnap : Snap?
    var inputArray = [KingfisherSource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let snap = self.selectedSnap {
            
            timeLabel.text = "Time Left: \(snap.timeDifference)"
            
            for image in snap.imageUrlArray {
                inputArray.append(KingfisherSource(urlString: image)!)
            }
            let imageSlideShow = ImageSlideshow(frame: CGRect(x: 10, y: 10, width: self.view.frame.width * 0.95 , height: self.view.frame.height * 0.90))
            imageSlideShow.backgroundColor = UIColor.white
            
            let pageIndicator = UIPageControl() // resmin alttaki hangi resimde olduğunu gösteren slider
            pageIndicator.currentPageIndicatorTintColor = UIColor.lightGray
            pageIndicator.pageIndicatorTintColor = UIColor.black
            imageSlideShow.pageIndicator = pageIndicator
            
            
            imageSlideShow.contentScaleMode = UIViewContentMode.scaleAspectFit
            imageSlideShow.setImageInputs(inputArray)
            self.view.addSubview(imageSlideShow)
            self.view.bringSubviewToFront(imageSlideShow) // seçtiğiniz görünüm önde görünür
            
        }
    }
}
