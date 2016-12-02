//
//  Extensions.swift
//  Firebase Email Verification
//
//  Created by Emil Shirima on 12/2/16.
//  Copyright © 2016 Emil Shirima. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

extension FIRAuth
{
    func createUserAccount(withEmail email: String, password: String)
    {
        self.createUser(withEmail: email, password: password, completion: {(user: FIRUser?, error: Error?) in
            
            if error == nil
            {
                print("+++++++++++++++++++++++++++++++++++++++++")
                print("User account was successfully created")
                print("*****************************************")
            }
            else
            {
                print("+++++++++++++++++++++++++++++++++++++++++")
                print("Oooops...Error with account creation")
                print(error!.localizedDescription)
                print("*****************************************")
            }
        })
    }
    
    func signInUser(withEmail email: String, password: String)
    {
        signIn(withEmail: email, password: password, completion: {(user: FIRUser?, error: Error?) in
            
            if let user = self.currentUser
            {
                if !user.isEmailVerified
                {
                    print("+++++++++++++++++++++++++++++++++++++++++")
                    print("Email not verified...Sending verification link")
                    print("*****************************************")
                    self.sendEmailVerification()
                }
                else
                {
                    print("+++++++++++++++++++++++++++++++++++++++++")
                    print("Hoooray email is verified...Signing in")
                    print("*****************************************")
                }
            }
        })
    }
    
    func sendEmailVerification()
    {
        // if not verified, do so.
        if !(currentUser?.isEmailVerified)!
        {
            currentUser?.sendEmailVerification(completion: { (error: Error?) in
                
                // in case of any verification errors, inform the user
                if let verificationError = error
                {
                    print("+++++++++++++++++++++++++++++++++++++++++")
                    print("Ooooooops...Error with email verification")
                    print(verificationError.localizedDescription)
                    print("*****************************************")
                    return
                }
                print("+++++++++++++++++++++++++++++++++++++++++")
                print("Verification email was sent to : \(self.currentUser!.email)")
                print("*****************************************")
            })
        }
        else
        {
            print("+++++++++++++++++++++++++++++++++++++++++")
            print("Hooooooray....Account is verified")
            print("*****************************************")
            return
        }
    }
    
    func signOutUser()
    {
       try! self.signOut()
        
        print("+++++++++++++++++++++++++++++++++++++++++")
        print("User successfully signed out")
        print("*****************************************")
    }
}

extension UITextField
{
    var isEmpty: Bool
    {
        return self.text == "" ? true : false
    }
}
