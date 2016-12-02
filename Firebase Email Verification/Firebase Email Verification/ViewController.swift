//
//  ViewController.swift
//  Firebase Email Verification
//
//  Created by Emil Shirima on 12/1/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

/****************************************** README: **********************************************

** FIRAuth.auth()?.currentUser -> This is what you can use to check if their currently exists a logged in user. This helps so as to avoid having the user log in everytime they launch your app. This info is saved in the iOS keychain by default by FIrebase
 
 ** This code isn't production ready. It is merely meant to be a guide on how to go about handling email verifications with Firebase. My advice is for you to learn more about Firebase first. Watch a couple YouTube videos so as you may get an idea of how it functions. Afterwards, take a shot at the issue and try solving it in your own way.

****************************************** THANKS: **********************************************/

import UIKit
import FirebaseAuth

class ViewController: UIViewController
{
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if FIRAuth.auth()?.currentUser == nil // no logged in user
        {
            emailLabel.text = ""
        }
        // account created for user and email is verified
        else if (FIRAuth.auth()?.currentUser!.isEmailVerified)!
        {
            emailLabel.text = "Verified: \(FIRAuth.auth()!.currentUser!.email!)"
        }
        else // account created for user but email not verified
        {
            emailLabel.text = "Not Verified: \(FIRAuth.auth()!.currentUser!.email!)"
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func registerBtnAction(_ sender: UIButton)
    {
        // TODO: You might want to run more checks here. e.g. checking for email format validity, password lengths etc
        if emailTextField.isEmpty || passwordTextField.isEmpty
        {
            alertUser(withTitle: "Error", andMessage: "Fields cannot be empty")
        }
        // everything is fine so go ahead and create the account. Just because you have a created account it doesn't mean that your email is verified already. We first need to create an account for the user before doing anything else.
        else
        {
            emailLabel.text = "Creating account...."
            FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user: FIRUser?, error: Error?) in
                
                // everything went well so alert the user about it. Along with this, it's at this point that the variable FIRAuth.auth()?.currentUser is updated with the user's email and saved into the iOS keychain so as to avoid re-logging in in the future
                if error == nil
                {
                    self.emailLabel.text = ""
                    self.alertUser(withTitle: "Success", andMessage: "User account was successfully created. Proceed to signing in.")
                }
                else // this occurs when let's say an account with the same email already exists
                {
                    self.emailLabel.text = ""
                    self.alertUser(withTitle: "Error", andMessage: error!.localizedDescription)
                }
            })
        }
    }
    
    // After account creation, we can go ahead and try signing them into the app
    @IBAction func signInBtnAction(_ sender: UIButton)
    {
        emailLabel.text = "Signing In...."
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: {(user: FIRUser?, error: Error?) in
            
            // we check to see if there truly exists a currentUser.
            if let user = FIRAuth.auth()?.currentUser
            {
                // the user does exist so we go ahead and check to if their email isn't verified.
                if !user.isEmailVerified
                {
                    self.emailLabel.text = "Not Verified: \(FIRAuth.auth()!.currentUser!.email!)"
                    self.alertUser(withTitle: "Verification Error", andMessage: "The associated account is yet to be verified. A verification e-mail was sent to \(FIRAuth.auth()!.currentUser!.email!)")
                    self.sendEmailVerification()
                }
                else // user does exist and their email is verified as well. everything's good
                {                    
                    self.alertUser(withTitle: "Success", andMessage: "Your email was verified and signed in")
                    self.emailLabel.text = "Verified: \(FIRAuth.auth()!.currentUser!.email!)"
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                }
            }
            else // poooops..no one has ever logged into our app
            {
                self.alertUser(withTitle: "Error", andMessage: "No logged in user")
            }
        })
    }
    
    func sendEmailVerification()
    {
        // if not verified, do so
        if !(FIRAuth.auth()?.currentUser?.isEmailVerified)!
        {
            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: { (error: Error?) in
                
                // in case of any verification errors, inform the user
                if let verificationError = error
                {
                    self.alertUser(withTitle: "Verification Error", andMessage: verificationError.localizedDescription)
                    return
                }
                
                self.alertUser(withTitle: "Verification Update", andMessage: "Verification email was sent to \(FIRAuth.auth()!.currentUser!.email)")
            })
        }
        else
        {
            alertUser(withTitle: "Success", andMessage: "Account was successfully verified. Proceed to signing into your account")
        }
    }
    
    @IBAction func logOutBtnAction(_ sender: UIButton)
    {
        // make sure their's a logged in user first before signing out
        if FIRAuth.auth()?.currentUser != nil
        {
            try! FIRAuth.auth()?.signOut()
            
            alertUser(withTitle: "Success", andMessage: "User successfully logged out")
            
            emailLabel.text = ""
        }
        else
        {
            alertUser(withTitle: "Error", andMessage: "No logged in user")
        }
    }
    
    func alertUser(withTitle errorTitle: String, andMessage errorMessage: String)
    {
        let alert: UIAlertController = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITextFieldDelegate
{
    // this method delegation allows us to retract the keyboard once done typing in the textfields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        // if the current cursor is in the emailTextField, move it to password. If not; this means its already in the passwordTextField, then retract back the keyboard
        return textField == emailTextField ? passwordTextField.becomeFirstResponder() : textField.resignFirstResponder()
        
        // The above return statement is similar to this just incase its confusing
//        if textField == emailTextField
//        {
//            return passwordTextField.becomeFirstResponder()
//        }
//        else
//        {
//            return textField.resignFirstResponder()
//        }
    }
}
