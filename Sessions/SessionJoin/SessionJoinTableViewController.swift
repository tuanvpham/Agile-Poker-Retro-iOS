//
//  SessionJoinTableViewController.swift
//  ACC
//
//  Created by Leonardo Araque on 1/27/19.
//  Copyright © 2019 Leonardo Araque. All rights reserved.
//

import UIKit

class SessionJoinTableViewController: UITableViewController {

    var sessionArray = [Models.session]()
    var cellSession: Models.session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("sending")
        var request = URLRequest(url: URL(string : "http://127.0.0.1:8000/sessions/")!)
        request.httpMethod = "GET"
        request.setValue("application/json; charset=uft-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        request.setValue("application/json; charset=uft-8", forHTTPHeaderField: "Accept")
        request.setValue("JWT " + UserDefaults.standard.string(forKey: "token")!, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do{
                let decoder = JSONDecoder()
                self.sessionArray = try decoder.decode([Models.session].self, from: data!)
                DispatchQueue.main.async {
                    for session in self.sessionArray{
                        print(session.owner_email)
                    }
                    self.tableView.reloadData()
                }
            }catch{
                print(error)
            }
        }).resume()
                                   
                                   
                                   
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(sessionArray.count)
        return sessionArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SessionJoinTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SessionJoinTableViewCell else {
            fatalError("Type was wrong")
        }
        
        let thisSession = sessionArray[indexPath.row]
        //cell.cellSession = thisSession
        cell.sessionType.text = thisSession.session_type == "R" ? "Retro Board" : "Planning Poker"
        cell.sessionName.text = thisSession.title as String
        cell.sessionOwner.text = thisSession.owner_username as String
        cell.delegate = self
        /*
        if(thisSession.session_type == "R"){
            cell.join.addTarget(self, action: #selector(connectToRetroSession), for: .touchUpInside)
        }else{
            cell.join.addTarget(self, action: #selector(connectToPokerSession), for: .touchUpInside)
        }
        */
        return cell
    }
    
    @objc func connectToPokerSession(){
        print("poker")
            self.performSegue(withIdentifier: "jumpToPoker", sender: self)
    }
    
    @objc func connectToRetroSession(){
        print("retro")
        self.performSegue(withIdentifier: "jumpToRetro", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(self.cellSession!.title + " preparing")
        if(segue.identifier == "jumpToRetro"){
            if let nextViewController = segue.destination as? RetroSessionViewController {
                nextViewController.settings = Models.session()
                nextViewController.settings = self.cellSession
                nextViewController.settings!.owner_email = UserDefaults.standard.string(forKey: "email")!
                print(nextViewController.settings!.owner_username)
                print(nextViewController.settings!.title)
                print(nextViewController.settings!.session_type)
            }
        }
    
        else{
            if let nextViewController = segue.destination as? PokerSessionViewController {
                nextViewController.settings = self.cellSession
            }
        }
 
    }
    

    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SessionJoinTableViewController: SessionJoinTableViewCellDelegate{
    func didJoin(session: Models.session) {
        cellSession = session
        connectToRetroSession()
    }
}
