import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SettingsVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    
    
    @IBAction func logOutClicked(_ sender: Any) {
        do {
                try Auth.auth().signOut()
                self.performSegue(withIdentifier: "toSignInVC", sender: nil)
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
    }
}
