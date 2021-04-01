

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var usernameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func didTapLoginButton(_ sender: Any) {
        if usernameTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter username")
        }else if passwordTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter password")
        }else{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyBoard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showAlert(alertMessage:String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

