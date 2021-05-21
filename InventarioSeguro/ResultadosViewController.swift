//
//  ResultadosViewController.swift
//  InventarioSeguro
//
//  Created by Roger Eduardo Vazquez Tuz on 19/05/21.
//

import UIKit

class ResultadosTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rolloText: UILabel!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    
    
    override open var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 10
            frame.origin.x += 10
            frame.size.height -= 15
            frame.size.width -= 2 * 10
            super.frame = frame
        }
    }

    
}


class ResultadosViewController: UITableViewController {
    
    var displayResults:[Registro] = []
    let cellSpacingHeight: CGFloat = 8
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 95
        self.navigationController?.isNavigationBarHidden = false
        print(displayResults.count)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return displayResults.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
          let headerView = UIView()
          headerView.backgroundColor = UIColor.clear
          return headerView
      }
      
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultadosTableViewCell

        let res = displayResults[indexPath.section]
        
        
        print(res.idRollos)
        cell.rolloText.text = res.idRollos
        print(res.ubicacion)
        cell.locationText.text = res.ubicacion
        print(res.fecha)
        cell.dateText.text = res.fecha
        cell.layer.borderWidth = 1
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return cellSpacingHeight
    }

}
