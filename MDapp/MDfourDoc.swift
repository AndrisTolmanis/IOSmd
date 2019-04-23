//
//  MDfourDoc.swift
//  MDapp
//
//  Created by Andris Tolmanis on 21/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit

class MDfourDoc: UIViewController{
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadDocs()
    }
    
    func downloadDocs() -> Void{
        let url = URL(string: "https://api.github.com/repos/andristolmanis/sumstuff")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let validDictionary = jsonSerialized {
                        
                        print(validDictionary)
                        
                        
                        DispatchQueue.main.async{
                          
                        }
                        
                    } else {
                        print("Error: Dati nav derīgi")
                    }
                }  catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        task.resume()
            
        
    }

}
