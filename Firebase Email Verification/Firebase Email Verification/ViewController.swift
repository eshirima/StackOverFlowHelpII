//
//  ViewController.swift
//  Firebase Email Verification
//
//  Created by Emil Shirima on 12/1/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

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
        
        if FIRAuth.auth()?.currentUser == nil
        {
            emailLabel.text = ""
        }
        else if (FIRAuth.auth()?.currentUser!.isEmailVerified)!
        {
            emailLabel.text = "Verified \(FIRAuth.auth()?.currentUser!.email!)"
        }
        else
        {
            emailLabel.text = "Not Verified \(FIRAuth.auth()?.currentUser!.email!)"
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
            emailLabel.text = "Fields cannot be empty"
        }
        else
        {
            FIRAuth.auth()?.createUserAccount(withEmail: emailTextField.text!, password: passwordTextField.text!)
        }
    }
    
    @IBAction func signInBtnAction(_ sender: UIButton)
    {
        FIRAuth.auth()?.signInUser(withEmail: emailTextField.text!, password: passwordTextField.text!)
    }
    
    
    @IBAction func logOutBtnAction(_ sender: UIButton)
    {
        if FIRAuth.auth()?.currentUser != nil
        {
            FIRAuth.auth()?.signOutUser()
            emailLabel.text = ""
        }
        else
        {
            print("+++++++++++++++++++++++++++++++++++++++++")
            print("No Logged in User")
            print("*****************************************")
        }
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
