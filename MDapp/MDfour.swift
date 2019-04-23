//
//  MDfour.swift
//  MDapp
//
//  Created by Andris Tolmanis on 20/04/2019.
//  Copyright © 2019 Andris Tolmanis. All rights reserved.
//

import UIKit

struct GitHubContent {
    let name: String?
    let company: String?
    let bio: String?
    let imageUrl: String?
}

class MDfour: UIViewController {
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func btnConfirmPressed(_ sender: UIButton) {
        if let usr = txtUsername.text{
            fetchUserData(username: usr)
        }
    }
    
    func fetchUserData(username: String) -> Void {
        let url = URL(string: "https://api.github.com/users/\(username)")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
                    if let validDictionary = jsonSerialized {
                        
                        
                        let validName = validDictionary["name"] as? String
                        let validCompnay = validDictionary["company"] as? String
                        let validBio = validDictionary["bio"] as? String
                        let validImageUrl = validDictionary["avatar_url"] as? String
                        
                        DispatchQueue.main.async{
                            self.nameLabel.text = validName ?? "No name received"
                            self.companyLabel.text = validCompnay ?? "No company received"
                            self.bioLabel.text = validBio ?? "No bio received"
                            self.profileImage.downloaded(from: validImageUrl ?? "https://dummyimage.com/500x500/000/fff&text=Att%C4%93ls+nav+atrasts")
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

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
