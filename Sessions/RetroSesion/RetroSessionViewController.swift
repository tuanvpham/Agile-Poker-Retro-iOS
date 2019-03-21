//
//  RetroSessionViewController.swift
//  ACC
//
//  Created by Leonardo Araque on 3/13/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import UIKit

class RetroSessionViewController: UIViewController {
    
    var settings: Models.session? = nil
    var ws: WebSocket = WebSocket()
    
    
    @IBAction func start(_ sender: UIButton) {
    }
    @IBAction func cancel(_ sender: UIButton) {
    }
    @IBAction func exit(_ sender: UIButton) {
    }
    @IBOutlet weak var memberList: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.memberList.clearsOnInsertion = true
//        print(settings!.title + "loaded")
//        print(settings!.owner_username + "loaded")
//        print(settings!.session_type + "loaded")
//
//        print("ws://localhost:8000/lobby/" + self.settings!.title + "/?" + self.settings!.owner_email)
        memberList.insertText("test")
        //self.navigationController?.isNavigationBarHidden = true
        // Do any additional setup after loading the view.
        
        ws = WebSocket("ws://localhost:8000/lobby/" + self.settings!.title + "/?" + self.settings!.owner_email)
//        print("ws://localhost:8000/lobby/" + self.settings!.title + "/?" + self.settings!.owner_email)
        
        ws.event.close = {(Code: Int, Reason: String, Clean: Bool) -> Void in print(Reason)}
        ws.event.open = {
            print("opened")
            let sendThisUserJoined = Models.lobby()
            sendThisUserJoined.has_joined = UserDefaults.standard.string(forKey: "email")
            sendThisUserJoined.player = UserDefaults.standard.string(forKey: "email")
            let encoder = JSONEncoder()
            let sendingThis = try! encoder.encode(sendThisUserJoined)
//            var sendingString = "{\"itemType\" : \"what_went_well\", \"itemText\" : \"something went well\"}"
            let formatedJson = String(data: sendingThis, encoding: String.Encoding.utf8)
            self.ws.send(formatedJson)
        }
        
        ws.event.message = {(message: Any) -> Void in
            print("some message")
            let JSONstring = message as! String
            let JSONdata = JSONstring.data(using: String.Encoding.utf8)
            let decoder = JSONDecoder()
            let decodedMessage = try! decoder.decode(Models.lobby.self, from: JSONdata!)
            print(decodedMessage.has_joined! + " is working")
            switch decodedMessage.type {
            case "has_joined":
                print("has joined")
                self.displayHasJoined(message: decodedMessage)
            case "start_game":
                self.segueToRetro(message: decodedMessage)
            case "cancel_game":
                self.segueBackHome(message: decodedMessage)
            case "display_retro":
                self.displayRetro(message: decodedMessage)
            case "exit_game":
                self.userLeaveSession(message: decodedMessage)
            default:
                print("this type isn't valid")
            }
 
        }

    }
    
    func displayHasJoined(message: Models.lobby){
        self.memberList.insertText(message.player! + "has joined" + "\n")
    }
    
    func segueToRetro(message: Models.lobby){
        //memberList.insertText(message.player! + "has joined" + "\n")
        print("seguing to retro...")
    }
    
    func segueBackHome(message: Models.lobby){
        //memberList.insertText(message.player! + "has joined" + "\n")
        print("Cancelling Session...")
    }
    
    func displayRetro(message: Models.lobby){
        //ask tuan about this function
    }
    
    func userLeaveSession(message: Models.lobby){
        self.memberList.insertText(message.player! + "has left!" + "\n")
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


/*
ws.event.message = {(message: Any) -> Void in
    print("some message")
    if let text = message as? String {
        print("something received")
        print("From Django: \(text)")
        let newMessage: Data = text.data(using: String.Encoding.utf8)!
        let decoder = JSONDecoder()
        let decodedMessage = try! decoder.decode(Models.lobby.self, from: newMessage)
        print(decodedMessage.has_joined)
}
*/
