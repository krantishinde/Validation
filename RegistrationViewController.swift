

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.firstNameTextfield.delegate = self
        self.lastNameTextfield.delegate = self
        self.emailTextfield.delegate = self
        self.mobileNumberTextfield.delegate = self
    }
    
    
    
    
    // UITextField validation for alphabets and length
  
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print("should change characters in range called")
            var result = true
            
            if textField == firstNameTextfield{
                let allowedCharacterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: allowedCharacterSet) == nil
                let maxLength = 50
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                result = replacementStringIsLegal && newString.length <= maxLength
            }
            if  textField ==  lastNameTextfield{
                let allowedCharacterSet = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvxyz").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: allowedCharacterSet) == nil
                let maxLength = 50
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                result = replacementStringIsLegal && newString.length <= maxLength
            }
            if textField == mobileNumberTextfield{
                let disallowedCharacterSet = NSCharacterSet(charactersIn: "0123456789").inverted
                let replacementStringIsLegal = string.rangeOfCharacter(from: disallowedCharacterSet) == nil
                let maxLength = 10
                let currentString: NSString = (textField.text ?? "") as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                result = replacementStringIsLegal && newString.length <= maxLength
            }
            
            print(textField.text!)
            return result
            
        }
      
    
    
    
    
    
    //VAlidation

    @IBAction func didTapRegisterButton(_ sender: Any) {
        if firstNameTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter first name")
        }else if lastNameTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter last name")
        }else if emailTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter email")
        }else if !isValidEmail(email_Id:emailTextfield.text ?? ""){
            self.showAlert(alertMessage: "Please enter valid email")
        }else if mobileNumberTextfield.text == ""{
            self.showAlert(alertMessage: "Please enter mobile")
        }else{
            self.callOtpAPI()
        }
        
    }
    
    
    
 
     func isValidEmail(email_Id: String) -> Bool {
        let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email_Id)
    }
    
    func showAlert(alertMessage:String) {
        let alert = UIAlertController(title: "Alert", message: alertMessage,preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { _ in
        
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //OTP API Calling
    
    func callOtpAPI(){
        let parameters = ["mobile_no":mobileNumberTextfield.text!] as [String : Any]
        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
        var request = URLRequest(url: URL(string: "http://")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard data != nil else {
            print(String(describing: error))
            return
          }
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
        
                    if let resultState = json["resultState"] as? String {
                        DispatchQueue.main.async {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyBoard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.showAlert(alertMessage: resultState)
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            print(jsonData as Any)
         
        }

        task.resume()
        
    }
    
}
