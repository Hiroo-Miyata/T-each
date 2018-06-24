

import UIKit


class LandingViewController: UIViewController {
    
    //MARK: Properties
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return UIInterfaceOrientationMask.portrait
        }
    }
    
    func pushTo(viewController: ViewControllerType)  {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch viewController {
        case .signin:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Welcome") as! SignInViewController
            self.present(vc, animated: false, completion: nil)
        case .login:
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! TabBarViewController
            self.present(vc, animated: false, completion: nil)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let userInformation = UserDefaults.standard.dictionary(forKey: "userInformation") {
            let email = userInformation["email"] as! String
            let password = userInformation["password"] as! String
            print(email)
            print(password)
            User.loginUser(withEmail: email, password: password, completion: { [weak weakSelf = self] (status) in
                DispatchQueue.main.async{
                    if status == true {
                        weakSelf?.pushTo(viewController: .login)
                    } else {
                        weakSelf?.pushTo(viewController: .signin)
                    }
                    weakSelf = nil
                }
            })
        } else {
            self.pushTo(viewController: .signin)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

