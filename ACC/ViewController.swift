//
//  ViewController.swift
//
//
//  Created by Leonardo Araque on 11/22/18.
//  Copyright © 2018 Leonardo Araque. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct messageStruct : Codable{
        var userId : Int
        var id : Int
        var title : String
        var completed : Bool
    }
    
    @IBOutlet weak var imageContainer: UIImageView!
    
    
    @IBOutlet weak var displayJSON: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000")!)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                let jsonDecoder = JSONDecoder()
                let responseModel = try jsonDecoder.decode(messageStruct.self, from: data!)
                print(responseModel)
                DispatchQueue.main.async {
                    self.displayJSON.text = responseModel.title
                    self.displayJSON.sizeToFit()
                }
            } catch {
                print("JSON Serialization error")
            }
        }).resume()
    }
}


