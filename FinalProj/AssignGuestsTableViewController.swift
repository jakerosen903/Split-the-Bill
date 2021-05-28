//
//  AssignGuestsTableViewController.swift
//  FinalProj
//
//  Created by Blake Underwood on 4/2/21.
//

import UIKit

class AssignGuestsTableViewController: UITableViewController {

    var guests: [Guest?] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    private func getParentIndex(expandedIndex: Int) -> Int {
        
        var selectedCell: Guest?
        var selectedIndex = expandedIndex
        
        while (selectedCell == nil && selectedIndex >= 0) {
            
            selectedIndex -= 1
            selectedCell = guests[selectedIndex]
        }
        
        return selectedIndex
    }
    
    private func expandCell(tableView: UITableView, index: Int) {
        
        if let foods = guests[index]?.foods {
            
            for i in 1...foods.count {
                guests.insert(nil, at: index + i)
                tableView.insertRows(at: [IndexPath(row: index + i, section: 0)], with: .top)
            }
        }
    }
    
    private func contractCell(tableView: UITableView, index: Int) {
        
        if let foods = guests[index]?.foods {
            
            for _ in 1...foods.count {
                guests.remove(at: index+1)
                tableView.deleteRows(at: [IndexPath(row: index+1, section: 0)], with: .top)
            }
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return guests.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        print("reaches func")
        if let guest = guests[indexPath.row] {
            
            let defaultCell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath) as! DefaultTableViewCell
            
            defaultCell.guestNameLabel.text = guest.name
            
            
            defaultCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.4)
            
            let roundedNumber = String(format: "%.2f", guest.owe)
            defaultCell.guestTotalLabel.text = "$\(roundedNumber)"
            
            return defaultCell
        }

        else {
            
            if let guest = guests[getParentIndex(expandedIndex: indexPath.row)] {
            
                let expandedCell = tableView.dequeueReusableCell(withIdentifier: "ExpandedCell", for: indexPath) as! ExpandedTableViewCell
            
                expandedCell.backgroundColor = UIColor(red: 220.0/255.0, green: 220.0/255.0, blue: 220.0/255.0, alpha: 0.15)

                let parentCellIndex = getParentIndex(expandedIndex: indexPath.row)
                
                let expandedIndex = indexPath.row - parentCellIndex - 1
            
                expandedCell.foodNameLabel.text = guest.foods[expandedIndex].name
                
                if expandedCell.foodNameLabel.text == "Tax" ||
                    expandedCell.foodNameLabel.text == "Tip" {
                    
                    expandedCell.foodNameLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
                }
                else {
                    expandedCell.foodNameLabel.font = UIFont.systemFont(ofSize: 17.0)
                }
                
                let roundedNumber = String(format: "%.2f", guest.foods[expandedIndex].price)
                expandedCell.foodPriceLabel.text = "$\(roundedNumber)"
                
                return expandedCell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (guests[indexPath.row]) != nil {
            return 60
        }
        else {
            return 40
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (guests[indexPath.row]) != nil {
            
            if (indexPath.row + 1 >= guests.count) {
                expandCell(tableView: tableView, index: indexPath.row)
            }
            else {
             
                if(guests[indexPath.row+1] != nil) {
                    expandCell(tableView: tableView, index: indexPath.row)
                }
                else {
                    contractCell(tableView: tableView, index: indexPath.row)
                }
            }
        }
    }
}
