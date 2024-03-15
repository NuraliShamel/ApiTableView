import UIKit
import Alamofire
import SnapKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let apiUrl = "https://swapi.dev/api/starships/"
    var starships: [Starship] = []

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        fetchStarships()
    }
    
    func fetchStarships() {
        AF.request(apiUrl).responseJSON { response in
            if let data = response.value {
                if let json = data as? [String: Any], let results = json["results"] as? [[String: Any]] {
                    for result in results {
                        if let starship = Starship(json: result) {
                            self.starships.append(starship)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                print("Error: \(response.error)")
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starships.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let starship = starships[indexPath.row]
        cell.textLabel?.text = starship.name
        return cell
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let starship = starships[indexPath.row]
        print("Selected starship: \(starship.name)")
    }
}

struct Starship {
    let name: String
    let model: String
    let manufacturer: String
    
    init?(json: [String: Any]) {
        guard let name = json["name"] as? String,
              let model = json["model"] as? String,
              let manufacturer = json["manufacturer"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.model = model
        self.manufacturer = manufacturer
    }
}
