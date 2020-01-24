//
//  ViewController.swift
//  SQLiteDatabase
//
//  Created by Marni Anuradha on 12/18/19.
//  Copyright © 2019 Marni Anuradha. All rights reserved.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    // declaration of variables
    
    var path:String!
    var dbConnection:Connection!
    
    var allContactsButton = [UIButton]()
    var allButtons = [UIButton]()
    
        static var firstName = [String]()
        static var lastName = [String]()
        static var  email = [String]()
        static var mobileNumber = [String]()
        static var id = [Int]()
    
        static var isContactButtonTapped = false
    static var contactButtonTapped:Int!
    @IBOutlet weak var stackView1: UIStackView!
    
    @IBOutlet weak var stackView2: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView1.spacing = 30
        stackView2.spacing = 30
        
        database()
        // Do any additional setup after loading the view.
    }
    
    func database()
    {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        do{
            dbConnection = try Connection("\(path)/db1.sqlite3")
            print(path)
            
           //try self.dbConnection!.run("Create Table if not Exists Contacts(ID Integer Primary Key AutoIncrement, FirstName,LastName,Email,MobileNumber)")

            }catch {
                    print("Unable to Connect/Open database")
                    
                }
            }

    override func viewWillAppear(_ animated: Bool) {
        
        for (x,y) in zip(allContactsButton, allButtons)
        {
            x.removeFromSuperview()
            y.removeFromSuperview()
        }
        
        allContactsButton = [UIButton]()
        allButtons = [UIButton]()
        
        
        do{
            let x = try! dbConnection!.run("SELECT * FROM Contacts")
            
            for(i,row) in x.enumerated()
            {
                var text = String()
                for(index,name) in x.columnNames.enumerated()
                {
                    print("\(name):\(row[index]!)")
                    
                    if(name == "FirstName")
                    {
                        ViewController.firstName.append(row[index]! as! String)
                        text = (row[index]! as! String)
                    }
                    
                    else if(name == "LastName")
                    {
                        
                        ViewController.lastName.append(row[index]! as! String)

                        text += " " + (row[index]! as! String)
                    }
                    
                    else if(name == "Email")
                    {
                        ViewController.email.append(row[index]! as! String)

                        text += " " + (row[index]! as! String)
                    }
                    
                    else if(name == "MobileNumber")
                    {
                        ViewController.mobileNumber.append(row[index]! as! String)

                        text += " " + (row[index]! as! String)
                    }
                    
                    else if(name == "ID")
                    {
                        ViewController.id.append(Int(row[index]! as! Int64))

                    }
                }
                
                // buttons for details and update
                
                let contactButton = UIButton()
                contactButton.setTitle(text, for: UIControl.State.normal)
                contactButton.backgroundColor = UIColor.purple
                contactButton.titleLabel?.numberOfLines = 0
                contactButton.addTarget(self, action: #selector(onButtonContactTap(button: )), for: UIControl.Event.touchUpInside)
                contactButton.tag = i
            contactButton.translatesAutoresizingMaskIntoConstraints = false
            contactButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                allContactsButton.append(contactButton)
                stackView1.addArrangedSubview(contactButton)
                
                // delete button
                
                let button = UIButton()
                button.setTitle("DELETE", for: UIControl.State.normal)
                button.backgroundColor = .gray
                button.titleLabel?.numberOfLines = 0
              //  button.layer.cornerRadius = 18
                button.setTitleColor(UIColor.black, for: UIControl.State.normal)
                button.addTarget(self, action:#selector(button_tap), for: UIControl.Event.touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                allButtons.append(button)
                stackView2.addArrangedSubview(button)
            }
        }
        catch{
            print("Not connected")
        }
    }
    
    // update button Event handler
    
    @objc func onButtonContactTap(button: UIButton)
    {
        ViewController.isContactButtonTapped = true
        ViewController.contactButtonTapped = button.tag
        
        let sVC = self.storyboard?.instantiateViewController(identifier: "secondVC") as! SecondViewController
        
        for(button1, button2) in zip(allButtons, allContactsButton)
        {
            button1.removeFromSuperview()
            
            button2.removeFromSuperview()
        }
        
        allContactsButton = [UIButton]()
        allButtons = [UIButton]()
        
        self.navigationController?.pushViewController(sVC, animated: true)
    }
    
    // Delete button Event handler
    
    @objc func button_tap(button: UIButton)
    {
        
        print("Delete Button Tag", button.tag)
        
        button.removeFromSuperview()
        
        allContactsButton[button.tag].removeFromSuperview()
        
        //allContactsButton.remove(at: button.tag)
        
        do{
            
            print("Data: ", ViewController.id[button.tag])
            let query = "DELETE FROM CONTACTS WHERE ID = \(ViewController.id[button.tag])"
            
            try dbConnection!.run(query)
            
            print(query)
            
        }
        
        catch{
            print("Data not deleted")
        }
    }
    
    
    @IBAction func onContactButtonTap(_ sender: Any) {
        
        for (a,b) in zip(allContactsButton, allButtons)
        {
            a.removeFromSuperview()
            b.removeFromSuperview()
        }
        
        allContactsButton = [UIButton]()
        
        allButtons = [UIButton]()
        
        let sVC = storyboard?.instantiateViewController(identifier: "secondVC") as! SecondViewController
        
        navigationController?.pushViewController(sVC, animated: true)
    }
}


