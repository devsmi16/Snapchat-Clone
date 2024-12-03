import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class SignInVC: UIViewController {
    
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func makeAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        guard let email = mailText.text, !email.isEmpty,
              let password = passwordText.text, !password.isEmpty else {
            presentAlert(title: "Error", message: "Please fill all fields!")
            return
        }
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (authResult, error) in
                guard let self = self else { return } // Olabilecek memory leak'i önlemek için
                if let error = error {
                    self.presentAlert(title: "Error!", message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }

        func presentAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    
    
    @IBAction func signUpClicked(_ sender: Any) {
        if mailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: mailText.text!, password: passwordText.text!){
                authdata, error in
                if error != nil {
                    self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Erorr")
                }else{
                    if FirebaseApp.app() == nil {
                        FirebaseApp.configure()
                    }

                    guard let username = self.usernameText.text, !username.isEmpty,
                          let email = self.mailText.text, !email.isEmpty else {
                        self.makeAlert(title: "Error!", message: "Username or email cannot be empty.")
                        return
                    }

                    let userDictionary: [String: Any] = ["username": username,"email": email]

                    let firestore = Firestore.firestore()

                    firestore.collection("userInfo").addDocument(data: userDictionary) { error in
                        if let error = error {
                            self.makeAlert(title: "Error!", message: error.localizedDescription)
                        } else {
                            self.makeAlert(title: "Success!", message: "User info saved successfully.")
                        }
                    }
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
            }
        }else{
            self.makeAlert(title: "Error!", message: "Please fill all fields!")
        }
    }
    
   
}
