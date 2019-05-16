import UIKit
import SwiftyJSON

class MDfourMedia: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var table: UITableView!
    var jsonData = [[String:String]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.rowHeight = 50
        table.delegate = self
        table.dataSource = self
        searchRepo()
        sleep(1)
        //        table.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Getting row count!")
        return jsonData.count
    }
    // Populate the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Filling the table")
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) as! ListCellMedia
        let row = indexPath.row
        let url = jsonData[row]["download_url"] ?? "That file"
        let name = jsonData[row]["name"] ?? "This link"
        cell.name = name
        cell.link = url
        cell.decorate()
        return cell
    }
    
    func searchRepo(){
        let session = URLSession.shared
        let url = URL(string:"https://api.github.com/repos/andristolmanis/sumstuff/contents")!
        let task = session.dataTask(with: url, completionHandler: { data, response, error in
            if error != nil{
                print("Get data error")
            }else{
                if let json = try? JSON(data: data!){
                    for (_,subJson):(String, JSON) in json {
                        if subJson["name"].string!.hasSuffix(".mp3") ||
                            subJson["name"].string!.hasSuffix(".mp4") {
                            self.jsonData.append(["name": subJson["name"].string!, "download_url": subJson["download_url"].string!])
                        }
                    }
                }
                //                print(self.jsonData)
            }
        })
        task.resume()
    }
}

class ListCellMedia: UITableViewCell{
    @IBOutlet var lblName: UILabel!
    var name:String = "Cool file"
    var link:String = "lets go"
    @IBAction func download(_ sender: UIButton) {
        print(link)
        downloadSomething(url: link, name: name)
    }
    func decorate() {
        self.lblName.text = name
    }
}
