//
//  WelcomeSessionViewController.swift
//  ACC
//
//  Created by Leonardo Araque on 1/20/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import UIKit

class WelcomeSessionViewController: UIViewController {

    @IBOutlet weak var displayEmail: UILabel!
    
    @IBOutlet weak var displayUsername: UILabel!
    @IBOutlet weak var displayToken: UILabel!
    @IBAction func logOut(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        let data = UserDefaults.standard
        
        displayEmail.text = data.string(forKey: "email")
        displayUsername.text = data.string(forKey: "username")
        displayToken.text = data.string(forKey: "token")
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
