import UIKit
import FirebaseFirestore
import FirebaseAuth
import Firebase
import SDWebImage

class FeedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let firestoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        getUserInfo()
        getSnapsFromFirebase()
    }
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getSnapsFromFirebase() {
        firestoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { (snapshot, error) in
            if error != nil {
                self.presentAlert(title: "Error!", message: error?.localizedDescription ?? "Something went wrong!")
            }else{
                if snapshot?.isEmpty == false && snapshot != nil {
                    self.snapArray.removeAll(keepingCapacity: false)
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String{
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    
                                    if let difference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        if difference >= 24 { // 24 saat geçtiyse firebase'den sil
                                            
                                            self.firestoreDatabase.collection("Snaps").document(documentId).delete { error in
                                                if error != nil {
                                                    self.presentAlert(title: "Error!", message: error?.localizedDescription ?? "Something went wrong!")
                                                }
                                            }

                                        }else{
                                            let snap = Snap(username: username, imageUrlArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - difference)
                                            self.snapArray.append(snap)
                                        }
                                    }
                                }
                           }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func getUserInfo() {
        firestoreDatabase.collection("userInfo").whereField("mail", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { (querySnapshot, error) in
            if error != nil {
                self.presentAlert(title: "Error!", message: error?.localizedDescription ?? "Something went wrong!")
            }else {
                if querySnapshot?.isEmpty == false && querySnapshot != nil {
                    for document in querySnapshot!.documents {
                        if let username = document.get("username") as? String{
                            UserSingleton.sharedUserInfo.mail = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        }
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUsernameLabel.text = snapArray[indexPath.row].username
        let imageUrl = snapArray[indexPath.row].imageUrlArray[0]
        cell.feedImageView.layer.cornerRadius = cell.feedImageView.frame.height / 2
        cell.feedImageView.clipsToBounds = true
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageUrlArray[0]))
        return cell
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            let destinationVC = segue.destination as! SnapVC
            destinationVC.selectedSnap = chosenSnap
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
}
