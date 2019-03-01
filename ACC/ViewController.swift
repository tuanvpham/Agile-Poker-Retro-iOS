//
//  ViewController.swift
//
//
//  Created by Leonardo Araque on 11/22/18.
//  Copyright © 2018 Leonardo Araque. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    struct messageStruct : Codable{
        var userId : Int
        var id : Int
        var title : String
        var completed : Bool
    }
    
    struct usernamePass : Codable {
        var email: String
        var password: String
    }
    
    struct loginReturn : Codable{
        var token: String
        var email: String
        var username: String
    }
    
    @IBOutlet weak var imageContainer: UIImageView!
    @IBOutlet weak var displayText: UILabel!
    
    @IBOutlet weak var inputPassword: UITextField!
    
    @IBAction func inputProcess(_ sender: UIButton) {
        login()
        print("ran")
    }
    @IBAction func bypassLogin(_ sender: Any) {
        byPassLogin()
    }
    @IBOutlet weak var inputEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        inputPassword.delegate = self
        inputEmail.delegate = self
        
        
        
        let imageURL = URL(string: "https://www.ucf.edu/brand/files/2016/07/UCF-Tab-Signature-lockup_vertical-KG-7406.png")!
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            if (error == nil){
                
                let loadedImage = UIImage(data: data!)
                DispatchQueue.main.async {
                    self.imageContainer.image = loadedImage
                }
            }
        }
        task.resume()
        let ws = WebSocket("ws://localhost:8000/retro/Test/?abaeous@knights.ucf.edu")
        ws.event.close = {(Code: Int, Reason: String, Clean: Bool) -> Void in print(Reason)}
        ws.event.open = {print("opened")
            //var jsonSend = Models.webSocketRetro(type: "what_went_well", text: "something went well")
            //let encoder = JSONEncoder()
            //var sendingThis = try! encoder.encode(jsonSend)
            var sendingString =
            "{\"itemType\" : \"what_went_well\", \"itemText\" : \"something went well\"}"
            ws.send(sendingString)

        }

        ws.event.message = {(message: Any) -> Void in
            if let text = message as? String {
                print("From Django: \(text)")
            }
        }
       
        
        

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    
    func login(){
        
        inputEmail.text = "abaeous@knights.ucf.edu"
        inputPassword.text = "onetwothree"
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/users/")!)
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        //let inpuT = usernamePass(email: "tuanvpham32@outlook.com", password: "Pviett#8613")
        let inpuT = Models.LoginInput(email: inputEmail.text! as String, password: inputPassword.text! as String)
        //print(inpuT)
        //print(input2)
        
        let encoder = JSONEncoder();
        request.httpBody = try! encoder.encode(inpuT)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do{
                let decoder = JSONDecoder()
                let responseJson = try decoder.decode(Models.LoginOutput.self, from: data!)
                DispatchQueue.main.async {
                    print(responseJson.email + "\n")
                    print(responseJson.username + "\n")
                    print(responseJson.token + "\n")
                    let usrDefaults = UserDefaults.standard
                    usrDefaults.set(responseJson.email, forKey: "email")
                    usrDefaults.set(responseJson.username, forKey: "username")
                    usrDefaults.set(responseJson.token, forKey: "token")
                    
                    let viewController:UIViewController = UIStoryboard(name: "Sessions", bundle: nil).instantiateViewController(withIdentifier: "WelcomeSession") as UIViewController
                    
                    self.present(viewController, animated: false, completion: nil)
                }
                
            } catch{
                print(error)
            }
            
        }).resume()
    }
    
    func byPassLogin(){
        let viewController:UIViewController = UIStoryboard(name: "Sessions", bundle: nil).instantiateViewController(withIdentifier: "SessionSettings") as UIViewController
        
        self.present(viewController, animated: false, completion: nil)
    }

}

