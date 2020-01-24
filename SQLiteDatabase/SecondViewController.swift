//
//  SecondViewController.swift
//  SQLiteDatabase
//
//  Created by Marni Anuradha on 12/19/19.
//  Copyright © 2019 Marni Anuradha. All rights reserved.
//

import UIKit
import SQLite

class SecondViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    
    @IBOutlet weak var lastNameTF: UITextField!
    
    @IBOutlet weak var emailTF: UITextField!
    
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    
    
    
    
    var path:String!
    var dbConnection:Connection!

    override func viewDidLoad() {
        super.viewDidLoad()

        firstNameTF.keyboardType = .asciiCapable
        lastNameTF.keyboardType = .asciiCapable
        emailTF.keyboardType = .emailAddress
        mobileNumberTF.keyboardType = .namePhonePad
        
        if(ViewController.isContactButtonTapped)
        {
            
            firstNameTF.text = ViewController.firstName[ViewController.contactButtonTapped]
            
            lastNameTF.text = ViewController.lastName[ViewController.contactButtonTapped]
            
            emailTF.text = ViewController.email[ViewController.contactButtonTapped]
            
            mobileNumberTF.text = ViewController.mobileNumber[ViewController.contactButtonTapped]
            
        }
        // getting path and creating database and table
        path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do{
            dbConnection = try Connection("\(path!)/db1.sqlite3")
            print(path!)
            
           try dbConnection.run("CREATE TABLE IF NOT EXISTS Contacts(ID Integer Primary Key AutoIncrement, FirstName,LastName,Email,MobileNumber)")

            }catch {
                    print("Unable to Connect/Open database")
                    
                }
            }

    

    @IBAction func saveBtnTap(_ sender: UIButton) {
        if(ViewController.isContactButtonTapped)
        {
        do{
            try dbConnection!.run("UPDATE CONTACT SET FirstName = '\(firstNameTF.text!)', LastName = '\(lastNameTF.text!)', Email = '\(emailTF.text!)', MobileNumber = '\(mobileNumberTF.text!)'")
            
            print("Data updated")
            }
        catch{
            print("Data not updated")
            }
            
        }
        else
        {
            do{
                
                try dbConnection!.run("INSERT INTO CONTACTS(FirstName,LastName,Email,MobileNumber) VALUES(?,?,?,?)", firstNameTF.text!, lastNameTF.text!, emailTF.text!, mobileNumberTF.text!)
            
            firstNameTF.text = ""
            lastNameTF.text = ""
            emailTF.text = ""
            mobileNumberTF.text = ""
            
        }
        catch{
            print("Unable to Catch")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}
